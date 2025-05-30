# Scripts - Public Cloud - Azure

## Environment - Prod

## Platform

* Linux : [Ubuntu Server](https://ubuntu.com/download/server/)
  * App : PHP
  * Cache : Redis
  * Database : PostgreSQL
  * Message : RabbitMQ
  * Server : Nginx

## Project

* Connect Instance - [Document](https://guide.ncloud-docs.com/docs/ko/server-overview)

```bash
sudo chmod 400 "${KEY_PATH}/{your name}.pem"

ssh -i "${KEY_PATH}/{your name}.pem/${KEY_NAME}" root@"{HOST}"
```

* Create SSH Key

```bash
rlim@gram:~$ ssh-keygen -f ~/.ssh/id_sourcecommit -t rsa -b 2048
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in id_sourcecommit
Your public key has been saved in id_sourcecommit.pub
The key fingerprint is:
SHA256:zSc6aoecGQlmDx7k+OwS/3u9LgTFpvhi1VRH9U2Q0lk rlim@gram
The key's randomart image is:
+---[RSA 2048]----+
|       . ...ooo=E|
|    .   =  .. +o.|
|   + . *     .  o|
|  . O + .o       |
|   * B oS + .    |
|  . * = .. o     |
|   = o *o.       |
|  . o *.+..      |
|   . o++ oo.     |
+----[SHA256]-----+
rlim@gram:~$ 
rlim@gram:~$ cat ~/.ssh/id_sourcecommit.pub

rlim@gram:~$ vi ~/.ssh/config
Host devtools.ncloud.com
User [콘솔에 등록된 SSH 키 값]
IdentityFile ~/.ssh/id_sourcecommit
HostkeyAlgorithms +ssh-rsa
PubkeyAcceptedAlgorithms +ssh-rsa
```

### Server

* User - adduser : ubuntu

```bash
sudo adduser --home /home/ubuntu --uid 2000 --shell /bin/bash ubuntu

sudo usermod -aG sudo ubuntu
sudo usermod -aG www-data ubuntu
```

```bash
sudo chage -m 3 -M 100 -W 60 -I 30 -E 2099-12-30 ubuntu

sudo grep ubuntu /etc/shadow
sudo grep ubuntu /etc/passwd

sudo chage -l ubuntu
```

## Project

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
./scripts/cloud/azure/instance/deploy.sh
```

### Database - PostgreSQL

* Configure databases

```bash
./tools/ide/migrate.sh
```

## Reference

### Server

* Cloud
  * Azure
