# Exercises

## Create a Dockerfile for Gerrit

See [Dockerfile](./Dockerfile)
Build and run
```bash
docker build -t nokia-training:day-1 .
docker run --privileged -p 29418:29418 -p 8080:8080 nokia-training:day-1
```

## Add SSH key to Admin
- Sign in as admin
- Click gear icon in top right
- Click `SSH Keys` in left-nav
- Paste public key
- Click `Add new SSH key`

## Get Gerrit version using [SSH](https://gerrit-review.googlesource.com/Documentation/cmd-index.html)
```bash
ssh-keygen -R  [nokia-training-8.gerritforgeaws.com]:29418
ssh -p 29418 admin@nokia-training-8.gerritforgeaws.com gerrit version
```

## Get Gerrit version using [REST](https://gerrit-review.googlesource.com/Documentation/rest-api.html)
- `curl http://nokia-training-8.gerritforgeaws.com:8080/config/server/version`
- Calls are done anonymously. Prepend `/a` to path for authenticated requests

## Create a repo (UI)
- Top-nav `Browse` -> `Repositories`
- Top right - `Create New`
- Populate and create

## Create a change with a different user

### Sign in as a 'Registered User'
- Register a new user
- Click gear icon in top right
- Click `Email Addresses` in left-nav
- Add a new email (e.g. foo@bar.com) and click `Send Verification`

### Add SSH key
- Click `SSH Keys` in left-nav
- Paste public key
- Click `Add new SSH key`

### Push a change
- Top-nav `Browse` -> `Repositories` -> `test-repo`
- Change to `SSH` tab, copy `Clone with commit-msg hook` section
- Paste into terminal
- Configure git with your new user
```bash
cd test-repo
git config -f .git/config user.name Foo Bar
git config -f .git/config user.email foo@bar.com
```
- Create a change and push it
 ```bash
touch foo
git add foo
git commit -m'My first commit'
git push origin HEAD:refs/for/master
```

## Submit a change
- Fulfill submit requirements
- Top right - Submit change

## Create a custom label

### UI

#### Add custom label
- Top-nav `Browse` -> `Repositories` -> `test-repo`
- Left-nav `Commands` -> `Edit repo config`
- Add following
```
[label "External-Library-Check"]
    description = "External Library Check"
    value = -2 Rejected
    value = -1 Fails
    value = 0 No score
    value = +1 Verified
    value = +2 Accepted
    copyCondition = changekind:NO_CODE_CHANGE
```
- Click `Save` (or `Save and Publish` for CR)

#### Allow users to submit label value
- Top-nav `Browse` -> `Repositories` -> `test-repo`
- Left-nav `Access`
- Click `Edit`
- Click `Add Reference`
- Change `refs/for/*` to `refs/*`
- Select `Label External-Library-Check` and click `Add`
- Type `Administrators`, select `Allow` `-2` to `+2`
- Repeat for `Registered Users`
- `Save` (or `Save for review` for CR)
- Confirm by checking an active change, we should see the label listed on
the left and when clicking `Reply` we should be allowed to choose a value
within our user's permitted range

### Command line
- `git fetch origin refs/meta/config && git checkout FETCH_HEAD`
- Edit `project.config`
- Add following
```
[label "External-Library-Check"]
    description = "External Library Check"
    value = -2 Rejected
    value = -1 Fails
    value = 0 No score
    value = +1 Verified
    value = +2 Accepted
    copyCondition = changekind:NO_CODE_CHANGE
[access "refs/*"]
    label-External-Library-Check = -2..+2 group Administrators
    label-External-Library-Check = -1..+1 group Registered Users
```
- Run
```bash
git commit -am'Add external library check label`
# No CR
git push origin HEAD:refs/meta/config
# OR with CR
git push origin HEAD:refs/for/refs/meta/config
```
- Confirm by checking an active change, we should see the label listed on
the left and when clicking `Reply` we should be allowed to choose a value
within our user's permitted range

## Create a WIP change (command line)
- Run
```bash
touch bar
git add bar
git commit -m'wip change'
git push origin HEAD:refs/for/master%wip
```

## Create a Private change (command line)
- Run
```bash
touch bar
git add bar
git commit -m'private change'
git push origin HEAD:refs/for/master%private
```

## Find change metadata in NoteDB
- Create a change
- Add a comment, Reply
- Run
```bash
git ls-remote
# Identify meta ref for change where ABCD is the change number, and CD are its last two digits (0-lpad)
git fetch origin refs/changes/CD/ABCD/meta && git log -p FETCH_HEAD
```

## Create a submit rule

- `git fetch origin refs/meta/config && git checkout FETCH_HEAD`
- Edit `project.config`
- Add following
```
[label "Code-Style"]
      description = Code Style
      value = -1 Nope
      value = 0 No score
      value = +1 Ok
      defaultValue = 0
      function = MaxWithBlock
      copyCondition = changekind:NO_CODE_CHANGE

[access "refs/*"]
    label-Code-Style = -1..+1 group Administrators
```
- Make sure submission is blocked if no Code-Style
- Add submission rule
```
[label "Code-Style"]
      description = Code Style
      value = -1 Nope
      value = 0 No score
      value = +1 Ok
      defaultValue = 0
      function = NoBlock
      copyCondition = changekind:NO_CODE_CHANGE

[access "refs/*"]
    label-Code-Style = -1..+1 group Administrators

[submit-requirement "Code-Style"]
  description = Code is properly styled and formatted
  applicableIf = -branch:refs/meta/config
  submittableIf = label:Code-Style=MAX AND -label:Code-Style=MIN
  canOverrideInChildProjects = true
```
- Make sure submission is still blocked if no Code-Style
- Override submission rule

```
[label "Code-Style"]
      description = Code Style
      value = -1 Nope
      value = 0 No score
      value = +1 Ok
      defaultValue = 0
      function = NoBlock
      copyCondition = changekind:NO_CODE_CHANGE

[access "refs/*"]
    label-Code-Style = -1..+1 group Administrators

[submit-requirement "Code-Style"]
  description = Code is properly styled and formatted
  applicableIf = -branch:refs/meta/config
  submittableIf = label:Code-Style=MAX AND -label:Code-Style=MIN
  canOverrideInChildProjects = true
  overrideIf = owner:theboss
```

- Show that change created by `theboss` doesn't need Code-Style for submission
