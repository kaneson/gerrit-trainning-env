# Gerrit primary 

## Spin up environment
* Gerrit primary
* Gerrit replica

```
cd day-2/3-primary-replica/
docker-compose up
```

## Tail the replication_log (on a separate terminal)

```bash
tail -f primary/logs/replication_log
```

## Add SSH key to Admin
- Login as admin
- Click gear icon in top right
- Click `SSH Keys` in left-nav
- Paste the content of your SSH public key (for example, `~/.ssh/id_rsa.pub`)
- Click `Add new SSH key`
- Observe in the `replication_log` the successful propagation of the git refs

## Create a repo (UI)
- Top-nav `Browse` -> `Repositories`
- Top right - `Create New`
- Populate and create
- Observe in the `replication_log` the successful propagation of the git refs

## Create a change
- Top-nav `Browse` -> `Repositories` -> `test-repo`
- Change to `SSH` tab, copy `Clone with commit-msg hook` section
- Paste into terminal (TODO: Check host name)
- Run the following

 ```bash
cd test-repo/
touch foo
git add foo
git commit -m'My first commit'
git push origin HEAD:refs/for/master
```

- Observe in the `replication_log` the successful propagation of the git refs

## Fetch from replica

- Clone repository from replica

```bash
cd /tmp
git clone ssh://admin@nokia-training-8.gerritforgeaws.com:29419/test-repo.git
git ls-remote
```

- Observe all refs, including the newly created change was replicated correctly.

# Guidelines

## Replication plugin

https://gerrit.googlesource.com/plugins/replication/+/refs/tags/v3.6.1

## Git daemon

https://git-scm.com/book/en/v2/Git-on-the-Server-Git-Daemon

## Clean up

If you  want to clean up the local environment from all the files that are
untracked you can do this:

```bash
docker-compose down
docker volume prune
git clean -ffdd
```