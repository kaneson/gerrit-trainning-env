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

# Get the war file
ADD --chown=gerrit \
    "https://gerrit-ci.gerritforge.com/job/Gerrit-bazel-stable-3.6/lastSuccessfulBuild/artifact/gerrit/bazel-bin/release.war" \
    /tmp/gerrit.war

# Change user
USER gerrit

# Init jar
RUN java -jar /tmp/gerrit.war init --batch --install-all-plugins --dev -d /var/gerrit && \
    rm /tmp/gerrit.war

# Start gerrit.sh as root
USER root

# Expose ssh and http ports
EXPOSE 29418 8080

# Make Gerrit output correct hyperlinks
RUN git config -f /var/gerrit/etc/gerrit.config gerrit.canonicalWebUrl http://nokia-training-8.gerritforgeaws.com:8080

# Start gerrit
ENTRYPOINT ["bash", "-c", "/var/gerrit/bin/gerrit.sh start && tail -f /var/gerrit/logs/*_log"]
