FROM rockylinux/rockylinux:10.1

COPY mail_dnf_packages /tmp/mail_dnf_packages/

RUN dnf -y install /tmp/mail_dnf_packages/*.rpm && \
    dnf clean all && \
    rm -rf /tmp/*

COPY enterpoint.sh /enterpoint.sh
RUN chmod +x /enterpoint.sh

EXPOSE 25 465 587

ENTRYPOINT ["/enterpoint.sh"]
