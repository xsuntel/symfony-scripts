# Tools - Git - GitHub

## Abstract

This project includes some scripts to develop a web application using Symfony Framework

## Platform

* Linux
* MacOS
* Windows

## Project

### Git - Config

#### Global

* Update default branch

```
git config --global user.name "Your Name"
git config --global user.email "you@examle.com"

git config --global init.defaultBranch main
git config --global credential.helper store

git config --global --list
```

#### Local

* Update Configuration

```
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
```
git config --local --unset credential.helper
```

* Check global configurations
```
git config --local credential.helper store
```

### Git - Command

#### Update the project

```
git config pull.rebase true

git reset --hard

git pull origin main -f
```

## Tools

### Git

* Clear main branch

```
./tools/git/clear.sh
```

## Reference

### Cloud

* AWS Codecommit - [Troubleshooting the credential helper](https://docs.aws.amazon.com/codecommit/latest/userguide/troubleshooting-ch.html)

### Tools

* Git            - [Documents](https://git-scm.com/)
