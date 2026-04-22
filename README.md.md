此容器只需要修改enterpoint.sh脚本中的用户配置的三个变量值，修改为自己对应的即可。
![[Pasted image 20260422222131.png|653]]
PROVIDER选择自己使用的邮箱
MAIL_USER选择邮箱账号
MAIL_PASS邮箱授权码
这里只示例新浪和qq邮箱授权码

## 1新浪邮箱授权码
![登录新浪，点击设置](https://i-blog.csdnimg.cn/direct/9ad216b4c7ab44d9907751f2f9f3d033.png)
## 1.2设置新浪邮箱客户端pop/imap/smtp
![新浪邮箱客户端pop/imap/smtp](https://i-blog.csdnimg.cn/direct/62b3ec6429d94567a43fda0ec13e7197.png)
## 1.3开启服务配置授权码
![开启授权码服务](https://i-blog.csdnimg.cn/direct/6bc4576fffbe4acfac0dfe3d429dee62.png)
**IMAP/POP3 服务器，用于接收邮件**，服务器的需求一般只发送邮件，不需要接收。
## 1.4验证授权码提示框
![授权码提示框](https://i-blog.csdnimg.cn/direct/ccad0eb0fd7a4c3c836a4c0cb36bde64.png)
## 1.5复制授权码
![授权码](https://i-blog.csdnimg.cn/direct/b2796b8a51604f3995d2f788d1135d1b.png)
## 2QQ邮箱授权码
## 2.1登录QQ邮箱，点击设置 ![[Pasted image 20260422223010.png]]
## 2.2点击账号与安全
![[Pasted image 20260422223233.png]]
## 2.3点击安全设置
![[Pasted image 20260422223348.png]]
## 2.4点击生成授权码
![[Pasted image 20260422223434.png]]
## 2.5验证
![[Pasted image 20260422223544.png]]
## 2.6复制到脚本
![[Pasted image 20260422223650.png]]
