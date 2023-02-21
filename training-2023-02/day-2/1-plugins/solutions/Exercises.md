# Gerrit with plugins and persistent volumes

## Verify

- Navigate to http://nokia-training-8.gerritforgeaws.com:8080
- Sign in as Admin
- Go to top-nav `Plugins` -> `Manage`

### Metrics reporter prometheus

In browser http://nokia-training-8.gerritforgeaws.com:8080/plugins/metrics-reporter-prometheus/metrics
In curl curl -H'Authorization: Bearer token123' 'http://nokia-training-8.gerritforgeaws.com:8080/plugins/metrics-reporter-prometheus/metrics'

### Healthcheck

curl http://nokia-training-8.gerritforgeaws.com:8080/config/server/healthcheck~status

#### Fix healthcheck

Copy `healthcheck.config` into the Dockerfile to configure this correctly

- `auth` - disable it
- `querychanges` - make a change to make this pass