# Task

Starting with the given [Dockerfile](./Dockerfile), mount the `cache`, `db`, `git`, `etc`, `logs` and `index` directories in
`/var/gerrit` so they survive a restart.

Add the `healthcheck` and `metrics-reporter-prometheus` plugins and verify they work.

Fix the `healthcheck` plugin (you can disable the `auth` check).
