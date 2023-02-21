FROM almalinux:8.5

# Install dependencies
RUN yum -y install \
    git \
    java-11-openjdk \
    procps \
    sudo \
    && yum -y clean all

# Add gerrit user
RUN adduser -m gerrit --home-dir /home/gerrit

# Create gerrit installation directory
RUN mkdir -p /var/gerrit && chown -R gerrit /var/gerrit

# Get the war file
ADD --chown=gerrit \
    "https://gerrit-ci.gerritforge.com/job/Gerrit-bazel-stable-3.6/lastSuccessfulBuild/artifact/gerrit/bazel-bin/release.war" \
    /tmp/gerrit.war

# Change user
USER gerrit

# Init jar
RUN java -jar /tmp/gerrit.war init --batch --install-all-plugins --dev -d /var/gerrit && \
    rm /tmp/gerrit.war

# Install plugins
ADD --chown=gerrit \
    https://gerrit-ci.gerritforge.com/job/plugin-healthcheck-bazel-master-stable-3.6/lastSuccessfulBuild/artifact/bazel-bin/plugins/healthcheck/healthcheck.jar \
    https://gerrit-ci.gerritforge.com/job/plugin-metrics-reporter-prometheus-bazel-master-stable-3.6/lastSuccessfulBuild/artifact/bazel-bin/plugins/metrics-reporter-prometheus/metrics-reporter-prometheus.jar \
    /var/gerrit/plugins/

ADD --chown=gerrit healthcheck.config /var/gerrit/etc/

# Start gerrit.sh as root
USER root

# Expose ssh and http ports
EXPOSE 29418 8080

# Make Gerrit output correct hyperlinks
RUN git config -f /var/gerrit/etc/gerrit.config gerrit.canonicalWebUrl http://nokia-training-8.gerritforgeaws.com:8080
RUN git config -f /var/gerrit/etc/gerrit.config plugin.metrics-reporter-prometheus.prometheusBearerToken token123
RUN git config -f /var/gerrit/etc/gerrit.config index.changes.commitWithin 1s

# Start gerrit
ENTRYPOINT ["bash", "-c", "sudo -u gerrit java -jar /var/gerrit/bin/gerrit.war reindex -d /var/gerrit && /var/gerrit/bin/gerrit.sh start && tail -f /var/gerrit/logs/*_log"]
