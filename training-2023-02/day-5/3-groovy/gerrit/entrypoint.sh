#!/bin/sh

echo "Init gerrit..."
java -jar /tmp/gerrit.war init --batch --install-all-plugins --dev -d /var/gerrit

echo "Setting config..."
git config -f /var/gerrit/etc/gerrit.config gerrit.canonicalWebUrl http://nokia-training-8.gerritforgeaws.com:8080
git config -f /var/gerrit/etc/gerrit.config gerrit.serverId 5357b9b7-0c0c-47fb-b888-26d987ccd0ce
git config -f /var/gerrit/etc/gerrit.config auth.type DEVELOPMENT_BECOME_ANY_ACCOUNT

echo "Running gerrit..."
/var/gerrit/bin/gerrit.sh run
