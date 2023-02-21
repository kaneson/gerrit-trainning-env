FROM almalinux:8.5

# Install dependencies
RUN yum -y install \
    git \
    java-11-openjdk \
    procps \
    && yum -y clean all

# Add gerrit user
RUN adduser -m gerrit --home-dir /home/gerrit

# Create gerrit installation directory
RUN mkdir -p /var/gerrit && chown -R gerrit /var/gerrit

ADD --chown=gerrit \
    "https://gerrit-ci.gerritforge.com/job/Gerrit-bazel-stable-3.6/lastSuccessfulBuild/artifact/gerrit/bazel-bin/release.war" \
    /tmp/gerrit.war

# Change user
USER gerrit

# Init jar
RUN java -jar /tmp/gerrit.war init --batch --install-all-plugins --dev -d /var/gerrit/

# Expose ssh and http ports
EXPOSE 29418 8080

COPY --chown=gerrit ./entrypoint.sh /bin

ENTRYPOINT /bin/entrypoint.sh
