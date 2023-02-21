#!/bin/sh

echo "*********** Init gerrit..."
java -jar /tmp/gerrit.war init --batch --install-all-plugins --dev -d /var/gerrit

echo "*********** Running gerrit..."
/var/gerrit/bin/gerrit.sh run
