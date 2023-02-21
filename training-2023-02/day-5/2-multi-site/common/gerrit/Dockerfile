FROM almalinux:8.5

# Install dependencies
RUN yum -y install \
    git \
    java-11-openjdk \
    procps \
    gettext \
    && yum -y clean all

ENV JAVA_HOME /usr/lib/jvm/jre-11-openjdk

# Add gerrit user
RUN adduser -m gerrit --home-dir /home/gerrit

# Create gerrit installation directory
RUN mkdir -p /var/gerrit && chown -R gerrit /var/gerrit && mkdir -p /home/gerrit/.ssh

ADD --chown=gerrit \
   "https://gerrit-ci.gerritforge.com/job/Gerrit-bazel-stable-3.6/lastSuccessfulBuild/artifact/gerrit/bazel-bin/release.war" \
   /var/gerrit/bin/gerrit.war

# ADD --chown=gerrit \
#     release.war \
#     /var/gerrit/bin/gerrit.war

COPY --chown=gerrit:users plugins /var/gerrit/plugins
COPY --chown=gerrit:users lib /var/gerrit/lib
COPY --chown=gerrit:users etc /tmp
COPY --chown=gerrit:users id_rsa* /home/gerrit/.ssh/
COPY --chown=gerrit:users ssh_config /home/gerrit/.ssh/config
RUN chown -R gerrit:gerrit /home/gerrit/.ssh && \
    chmod -R 600 /home/gerrit/.ssh/* && \
    chmod u+rwx /home/gerrit/.ssh

# Change user
USER gerrit

# Expose ssh and http ports
EXPOSE 29418 8080

COPY --chown=gerrit entrypoint.sh /usr/local/bin
COPY --chown=gerrit --chmod=777 run-gerrit.sh /run-gerrit.sh

RUN /run-gerrit.sh init

ENTRYPOINT /usr/local/bin/entrypoint.sh
