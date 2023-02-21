# Gerrit primary 

## Spin up environment
* Gerrit primary1
* Gerrit primary2
* haproxy (for loadbalancing)
* prometheus (for monitoring)

```
cd day-5/1-HA/
docker-compose up
```

* Gerrit is now available via haproxy, currently hitting `primary1`
* nokia-training-8.gerritforgeaws.com:8080 (haproxy)
* nokia-training-8.gerritforgeaws.com:8181 (primary1)
* nokia-training-8.gerritforgeaws.com:8282 (primary2)
* nokia-training-8.gerritforgeaws.com:9090 (prometheus)

## on two separate terminals, tail the primary1 and primary2 httpd logs

```bash
tail -f primary1/logs/httpd_log
tail -f primary2/logs/httpd_log
```

## websessions
* Open a websessions terminal, it's empty

## Generate HTTP password for Admin
- Login as admin
- Click gear icon in top right
- Click `HTTP Credentials` in left-nav
- Click `Geneerate new password`
- Copy the password in your clipboard and paste it to a text file
- Observe `websessions` now contains a session shared between primary1 and primary2
- Observe that admin user is logged in both `nokia-training-8.gerritforgeaws.com:8181` and `nokia-training-8.gerritforgeaws.com:8282`

## Create a repo (UI)
- Top-nav `Browse` -> `Repositories`
- Top right - `Create New`
- Populate and create

## Create a change
- Top-nav `Browse` -> `Repositories` -> `test-repo`
- Change to `HTTP` tab, copy `Clone with commit-msg hook` section
- Paste into terminal (check that the host name is `nokia-training-8.gerritforgeaws.com`)
- Run the following

 ```bash
cd test-repo/
touch foo
git add foo
git commit -m'My first commit'
git push origin HEAD:refs/for/master
```

- Observe in the `httpd_log` of `primary1` is being targeted by the haproxy
- Observe in the `httpd_log` of `primary2` calls to `/high-availabilty/` endpoint
- Observe by accessing directly primary1 (nokia-training-8.gerritforgeaws.com:8181) that changes are there
- Observe by accessing directly primary2 (nokia-training-8.gerritforgeaws.com:8282) that changes are there

## Metrics
- Navigate to prometheus: nokia-training-8.gerritforgeaws.com:9090
- Look for interesting metrics, for example: `receivecommits_push_count_total`
- Notice the collected metrics have been collected from `instance=primary1:8080`

## Failover
- Stop primary1 by issuing the following command

```bash
docker-compose kill primary1
```

- Observe now `primary2` takes over and serves traffic
- Browse `nokia-training-8.gerritforgeaws.com:8080` and observe `primary2` logs now being populated
- Push another change (this will now go to `primary2`)
- Navigate to prometheus: nokia-training-8.gerritforgeaws.com:9090
- Look for interesting metrics, for example: `receivecommits_push_count_total`
- Notice the collected metrics have been collected from `instance=primary2:8080`

## Failback

Re-establish `primary1`:

```bash
docker-compose up -d primary1
```

- Observe it will catch up with changes created in `primary2`
  - By observing the logs
  - By comparing the UIs (`nokia-training-8.gerritforgeaws.com:8181` and `nokia-training-8.gerritforgeaws.com:8282`)

# Guidelines

## Websession-flatfile plugin

https://gerrit.googlesource.com/plugins/websession-flatfile/

If you  want to clean up the local environment from all the files that are
untracked you can do this:

```bash
docker-compose down
docker volume prune
git clean -ffdd
```
