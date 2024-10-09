# Tools - Git - GitHub

## Dev Environment

### Platform

* Linux
* MacOS
* Windows

### Project

* Update your name for Git

```
git config --global user.email "Your Email Address"
git config --global user.name "Your Name"
```

* Update default branch

```
git config --global init.defaultBranch main
git config --get  init.defaultBranch
```

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

### App

#### Branch

* Clear main branch

```
./tools/git/clear.sh
```

#### Local User

* Reset password

```
./tools/git/reset.sh
```


## Reference

### Cloud

* AWS Codecommit - [Troubleshooting the credential helper](https://docs.aws.amazon.com/codecommit/latest/userguide/troubleshooting-ch.html)

### Tools

* Git            - [Documents](https://git-scm.com/)
