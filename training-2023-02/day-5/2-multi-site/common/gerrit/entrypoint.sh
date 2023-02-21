#!/bin/bash -e

echo "Rendering templates..."
export DOLLAR=$
envsubst < /tmp/gerrit.config.template > /var/gerrit/etc/gerrit.config
envsubst < /tmp/jgit.config.template > /var/gerrit/etc/jgit.config
envsubst < /tmp/multi-site.config.template > /var/gerrit/etc/multi-site.config
envsubst < /tmp/replication.config.template > /var/gerrit/etc/replication.config

echo "Copying healthcheck configuration..."
cp /tmp/healthcheck.config /var/gerrit/etc/healthcheck.config

if ! ls /var/gerrit/etc/ssh* 1> /dev/null 2>&1
then
  echo "Initialising site and keys ..."
  /run-gerrit.sh init
else
  echo "Site already initialized..."
fi

echo "Running Gerrit entrypoint"
exec /run-gerrit.sh
