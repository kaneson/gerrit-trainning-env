# Task

With the given [Docker compose file](./docker-compose.yml) and its dependencies, discover the symptoms of a congested LDAP connection pool.

Make sure you increase the simulated LDAP slowdown using the [container.javaOptions](https://gerrit-review.googlesource.com/Documentation/config-gerrit.html#container.javaOptions)
set to `-Dldap.slowdown.msec=N`

Try with small increases, starting from 100ms (100) up to 1s (1000).

Example:
```
[container]
        javaOptions = "-Dldap.slowdown.msec=1000"
```
