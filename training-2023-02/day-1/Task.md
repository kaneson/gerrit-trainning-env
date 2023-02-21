# Task

Create a docker image for Gerrit.

## Guidelines

### Base image
- almalinux:8.5

### Yum dependencies
- git
- java-11-openjdk
- procps

### Gerrit artifact
- https://gerrit-ci.gerritforge.com/job/Gerrit-bazel-stable-3.6/lastSuccessfulBuild/artifact/gerrit/bazel-bin/release.war

### Install directory
- `/var/gerrit`

### Unpack command (init)
- `java -jar /tmp/gerrit.war init --batch --install-all-plugins --dev -d /var/gerrit`

### Best practices
- Run `gerrit.sh` as `root`

### Expose ports
- HTTP `8080`
- SSH `29418`

### Run command
- `gerrit.sh run`
