# Tools - Git - GitHub

## Dev Environment

### Platform

* Linux
* MacOS
* Windows

### Project

#### Git - Global

* Update default branch

```
git config --global init.defaultBranch main
git config --get  init.defaultBranch
```

#### Git - Local

* Reset password
```
git config --local --unset credential.helper
git config --local --list
```

* Check global configurations
```
git config --local credential.helper store
git config --local --list
```

### Tools

#### Git

* Clear main branch

```
./tools/git/clear.sh
```

## Reference

### Cloud

* AWS Codecommit - [Troubleshooting the credential helper](https://docs.aws.amazon.com/codecommit/latest/userguide/troubleshooting-ch.html)

### Tools

* Git            - [Documents](https://git-scm.com/)
