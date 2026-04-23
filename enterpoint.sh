#!/bin/bash
set -e

# ============================================
# 用户配置区
# ============================================
PROVIDER="sina"                      # sina | qq | 163 | gmail | outlook
MAIL_USER=""                         # 邮箱账号
MAIL_PASS=""                         # 授权码,不是邮件密码
# ============================================

# 服务商配置
case "$PROVIDER" in
    sina)   SMTP_SERVER="smtp.sina.com"; SMTP_PORT="465" ;;
    qq)     SMTP_SERVER="smtp.qq.com"; SMTP_PORT="587" ;;
    163)    SMTP_SERVER="smtp.163.com"; SMTP_PORT="465" ;;
    gmail)  SMTP_SERVER="smtp.gmail.com"; SMTP_PORT="587" ;;
    outlook)SMTP_SERVER="smtp-mail.outlook.com"; SMTP_PORT="587" ;;
    *) echo "不支持的PROVIDER: $PROVIDER"; exit 1 ;;
esac

# 提取域名
EMAIL_DOMAIN=$(echo "$MAIL_USER" | cut -d'@' -f2)
HOSTNAME=$(hostname)

# 如果主机名已经包含 .localdomain，就不再加
if [[ "$HOSTNAME" != *".localdomain"* ]]; then
    MYHOSTNAME="${HOSTNAME}.localdomain"
else
    MYHOSTNAME="$HOSTNAME"
fi

echo "=========================================="
echo "Postfix 邮件服务配置"
echo "=========================================="
echo "服务商:   $PROVIDER"
echo "SMTP:     $SMTP_SERVER:$SMTP_PORT"
echo "发件人:   $MAIL_USER"
echo "域名:     $EMAIL_DOMAIN"
echo "主机名:   $MYHOSTNAME"
echo "=========================================="

# 生成 main.cf
cat > /etc/postfix/main.cf << EOF
# 基本设置
myhostname = ${MYHOSTNAME}
myorigin = ${EMAIL_DOMAIN}
inet_interfaces = localhost
inet_protocols = ipv4

# 中继设置
relayhost = [${SMTP_SERVER}]:${SMTP_PORT}

# SASL 认证
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = lmdb:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_sasl_tls_security_options = noanonymous
smtp_sasl_mechanism_filter = plain, login
smtp_sasl_type = cyrus

# TLS/SSL 加密
smtp_use_tls = yes
smtp_tls_wrappermode = yes
smtp_tls_security_level = encrypt
smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
smtp_tls_CApath = /etc/pki/tls/certs

# 发件人地址重写
smtp_generic_maps = lmdb:/etc/postfix/generic

# 收件限制
smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination

# 禁用本地收件
mydestination = 
local_recipient_maps = 

# 兼容性设置
compatibility_level = 3.6
EOF

# 生成 sasl_passwd
echo "[${SMTP_SERVER}]:${SMTP_PORT} ${MAIL_USER}:${MAIL_PASS}" > /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd
postmap lmdb:/etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd.lmdb

# 生成 generic
cat > /etc/postfix/generic << EOF
root@${MYHOSTNAME}              ${MAIL_USER}
root@$(hostname)                ${MAIL_USER}
@${MYHOSTNAME}                  ${MAIL_USER}
root@localhost                  ${MAIL_USER}
root                            ${MAIL_USER}
EOF
chmod 600 /etc/postfix/generic
postmap lmdb:/etc/postfix/generic
chmod 600 /etc/postfix/generic.lmdb

# 创建目录
mkdir -p /var/log/mail /var/spool/postfix
chmod 755 /var/log/mail /var/spool/postfix

# 生成 aliases
newaliases 2>/dev/null || postalias /etc/aliases 2>/dev/null || true

# 验证配置
postfix check || { echo "配置验证失败"; exit 1; }

echo "配置完成，启动 Postfix..."
exec postfix start-fg
