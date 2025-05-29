# Scripts - Public Cloud - AWS - Lightsail

## Environment - Prod

## Platform

* Linux : [Ubuntu Server](https://ubuntu.com/download/server/)
  * App : PHP
  * Cache : Redis
  * Database : PostgreSQL
  * Message : RabbitMQ
  * Server : Nginx

## Project

* Connect Instance in LightSail - [Document](https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-ssh-using-terminal.html)

```bash
sudo chmod 400 "${KEY_PATH}/{your name}.pem"

ssh -i "${KEY_PATH}/{your name}.pem/${KEY_NAME}" "${USER}@${HOST}"
```

* User

```bash
sudo cat /etc/passwd

# Login ID : x : UID : GID : Description : Home Directory : Login Shell
```

```bash
sudo cat /etc/shadow

# Login ID : User Password : Last changed data : MIN : MAX : WARNING : INACTIVE : EXPIRE : Flag
```

* Group

```bash
sudo cat /etc/group

# Group Name : x : GID : Group Members
```

```bash
sudo cat /etc/gshadow

# Group Name : Group Password : Administrator : Group Members
```

### App - Symfony Framework

* Update default variables in Prod Environment

```bash
vi .env.prod

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App


# >>>> Cache
REDIS_HOST={Your Host}
REDIS_PORT=6379

# >>>> Database
POSTGRES_HOST={Your Host}
POSTGRES_PORT=5432
POSTGRES_DB={Your default Database}
POSTGRES_USER={Your Name}
POSTGRES_PASSWORD={Your Password}

# >>>> Server
NGINX_HOST={Your Domain}
NGINX_PORT=80
```

* Update packages

```bash
cd ~/Downloads

sudo apt update -y
sudo apt install -y curl git wget unzip
sudo apt autoremove -y
```

* Work Directory

```bash
sudo mkdir -p /var/www
sudo mkdir -p /var/www/github
sudo chown -R "${LOGNAME}":"${LOGNAME}" /var/www/github

cd /var/www/github && if [ -d symfony ]; then rm -rf symfony ; fi
```

* Download this project

```bash
git clone https://github.com/xsuntel/symfony-scripts.git symfony

cd symfony && find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

* Deploy this project

```bash
./scripts/cloud/aws/lightsail/deploy.sh
```

### Database - PostgreSQL

* Configure databases

```bash
./tools/ide/migrate.sh
```

## Reference

### Server

* Cloud
  * AWS (Amazon Web Services)
    * [Lightsail](https://aws.amazon.com/ko/lightsail)
