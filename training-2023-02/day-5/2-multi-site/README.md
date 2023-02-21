# Multi-site setup for Gerrit

## Overview

This Gerrit multi-site setup is composed by three components:

1. Kinesis + DynamoDB
2. Gerrit primary server for British site
3. Gerrit primary server for Korean site

All the components are installed and available on a virtual domain `gerrit-test.uk`.

## Initialising the environment

```shell
make init
```

## Running the Gerrit multi-site components

```shell
make up
```

Prometheus will be available at http://nokia-training-8.gerritforgeaws.com:9090
Grafana will be available at http://nokia-training-8.gerritforgeaws.com:3000 (credentials: admin/admin)
