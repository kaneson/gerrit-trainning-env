# Exercises

## Run Gerrit and expose plugins volume

run:
```bash
cd 3-groovy/
docker-compose up
```

## Login to gerrit and install groovy-provider

- Login as admin
- Click `Install Plugins` (or navigate to `http://nokia-training-8.gerritforgeaws.com:8080/plugins/plugin-manager/static/index.html`)
- Search `groovy-provider`
- Click `Install` (The `groovy-provider.jar` is now downloaded in your `plugins` directory)
- Click `Done - Go to Gerrit` (in the top right corner)
- Alternatively you can drop the jar in the `plugins` directory:

```bash
cd plugins/
curl https://gerrit-ci.gerritforge.com/job/plugin-scripting-groovy-provider-bazel-master-stable-3.6/lastSuccessfulBuild/artifact/bazel-bin/plugins/groovy-provider/groovy-provider.jar
```

## Add SSH key to Admin
- Login as admin
- Click gear icon in top right
- Click `SSH Keys` in left-nav
- Paste public key
- Click `Add new SSH key`

## Create a repo (UI)
- Top-nav `Browse` -> `Repositories`
- Top right - `Create New`
- Populate and create

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

### Guidelines

#### Base image
- gerrit:3.6.2-almalinux8

#### Expose ports
- HTTP `8080`
- SSH `29418`

#### Gerrit groovy-provider
- https://gerrit.googlesource.com/plugins/scripting/groovy-provider/+/refs/heads/master

## List Gerrit plugins using [SSH](https://gerrit-review.googlesource.com/Documentation/cmd-index.html)
- `ssh -p 29418 admin@nokia-training-8.gerritforgeaws.com gerrit plugin ls`
