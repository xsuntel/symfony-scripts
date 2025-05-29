# Tools - Git - GitHub

## Environment - Dev/Prod

## Platform

* Linux
* MacOS
* Windows

## Project

### Git - Config

#### Global

* Update default branch

```bash
git config --global user.name "Your Name"
git config --global user.email "you@examle.com"

git config --global init.defaultBranch main
git config --global credential.helper store

git config --global --list
```

#### Local

* Update Configuration

```bash
git config --local core.editor vi
git config --local core.autocrlf false
git config --local color.ui true
git config --local diff.ui auto
git config --local format.pretty oneline
git config --local pull.rebase true
git config --local push.default simple

git config --local --list
```

* Reset password

```bash
git config --local --unset credential.helper
```

* Check global configurations

```bash
git config --local credential.helper store
```

### Git - Command

#### Update the project

```bash
git config pull.rebase true

git reset --hard

git pull origin main -f
```

## Tools

### Git

* Clear main branch

```bash
./tools/git/clear.sh
```

## Reference

### Cloud

* AWS Codecommit - [Troubleshooting the credential helper](https://docs.aws.amazon.com/codecommit/latest/userguide/troubleshooting-ch.html)

* Git            - [Documents](https://git-scm.com/)
