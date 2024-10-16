# Symfony Scripts

This project includes some shell-scripts for Full-Stack developer to develop a web application using [Symfony Framework](https://symfony.com)

* App : PHP
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx

## Platform

### Linux

* Work Directory

```
sudo mkdir -p /var/www
sudo mkdir -p /var/www/github
sudo chown -R "${LOGNAME}":"${LOGNAME}" /var/www/github

cd /var/www/github
```

### MacOS

* Work Directory

```
mkdir -p ~/Applications
mkdir -p ~/Applications/PhpStorm
mkdir -p ~/Applications/PhpStorm/GitHub

cd ~/Applications/PhpStorm/GitHub
```

### Windows

* Work Directory

```
mkdir -p ~/Applications
mkdir -p ~/Applications/PhpStorm
mkdir -p ~/Applications/PhpStorm/GitHub

cd ~/Applications/PhpStorm/GitHub
```

## Project

### Requirement

* Update your name for Git

```
git config --global user.email "you@examle.com"
git config --global user.name "Your Name"
```

```
git config --global init.defaultBranch main
git config --global credential.helper store
git config --global --list
```

* Download this project 

```
git clone https://github.com/xsuntel/symfony-scripts.git symfony

cd symfony

find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

* Check the latest version of Symfony - [Releases](https://symfony.com/releases)

  * Update Default variables
  
```
vi {PROJECT_PATH}/env.app
```

* Creating Symfony Applications - [Installing & Setting up the Symfony Framework](https://symfony.com/doc/current/setup.html)

```
./tools/tutorial/create.sh
```

### Deployment

* Linux
  * Ubuntu Desktop        - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/linux/ubuntu/Abstract.md)
* Macos
  * Desktop               - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/macos/device/Abstract.md)
* Windows
  * Desktop               - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/windows/device/Abstract.md)

### Development

* Check something in Dev Environment

```
./tools/ide/check.sh
```

* Migrate databases in Dev Environment

```
./tools/ide/migrate.sh
```

* Update some sources and Debugging it in Dev Environment

```
./tools/ide/update.sh
```

### Production

* Public Cloud
  * AWS (Amazon Web Services)
    * Elastic Beanstalk   - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/cloud/aws/elasticbeanstalk/Abstract.md)
    * Lightsail           - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/cloud/aws/lightsail/Abstract.md)
* Docker
  * Containers            - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/docker/containers/Abstract.md)

### Directories 

* [Symfony Framework](https://symfony.com)

```
    app/
    
        | -- Symfony Framework -- |

    diagrams/
        cloud/
          aws/
        instance/
          app/
          cache/
          database/
          server/
          tools/
        source/
          ...
    scripts/
        base/
        cloud/
        docker/
        linux/
        macos/
        windows/
    tests/
    tools/
        git/
        ide/
        tutorial/
    .env.app
    .env.dev
    .env.dev.local
    .env.prod
    .env.prod.local
    .gitignore
    .symfony.local.yaml
    LICENSE
    README.md
```

## Tutorial

* [SymfonyCasts](https://symfonycasts.com)

## Reference

* Tools
  * GitHub - [Wiki](https://github.com/xsuntel/symfony-scripts/wiki)

## License
This is available under the MIT License.
