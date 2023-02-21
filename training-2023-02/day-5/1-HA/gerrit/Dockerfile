FROM almalinux:8.5

# Install dependencies
RUN yum -y install \
    git \
    java-11-openjdk \
    procps \
    && yum -y clean all

ENV JAVA_HOME /usr/lib/jvm/jre-11-openjdk

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
RUN java -jar /tmp/gerrit.war init --batch --install-all-plugins --dev -d /var/gerrit

# Install plugins
ADD --chown=gerrit \
    https://gerrit-ci.gerritforge.com/job/plugin-healthcheck-bazel-master-stable-3.6/lastSuccessfulBuild/artifact/bazel-bin/plugins/healthcheck/healthcheck.jar \
    https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.6/job/plugin-high-availability-bazel-stable-3.6/lastSuccessfulBuild/artifact/bazel-bin/plugins/high-availability/high-availability.jar \
    https://gerrit-ci.gerritforge.com/job/plugin-metrics-reporter-prometheus-bazel-master-stable-3.6/lastSuccessfulBuild/artifact/bazel-bin/plugins/metrics-reporter-prometheus/metrics-reporter-prometheus.jar \
    https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.6/job/plugin-javamelody-bazel-master-stable-3.6/lastSuccessfulBuild/artifact/bazel-bin/plugins/javamelody/javamelody.jar \
    https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.6/job/plugin-websession-flatfile-bazel-master-stable-3.6/lastSuccessfulBuild/artifact/bazel-bin/plugins/websession-flatfile/websession-flatfile.jar \
    /var/gerrit/plugins/

# Install lib modules
ADD --chown=gerrit \
   https://repo1.maven.org/maven2/com/gerritforge/global-refdb/3.6.3.3/global-refdb-3.6.3.3.jar \
   /var/gerrit/lib/
# Expose ssh and http ports
EXPOSE 29418 8080

COPY --chown=gerrit ./entrypoint.sh /bin

ENTRYPOINT /bin/entrypoint.sh
