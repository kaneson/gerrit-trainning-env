FROM panubo/sshd:1.2.0

RUN apk add git

RUN adduser --h /home/gerrit -D gerrit && \
    mkdir -p /home/gerrit/.ssh && \
    chown -R gerrit:gerrit /home/gerrit/.ssh

COPY --chown=gerrit:gerrit id_rsa.pub /home/gerrit/.ssh/authorized_keys

COPY ./sshd_config /etc/ssh/sshd_config
COPY ./entrypoint.sh /bin

CMD /bin/entrypoint.sh
