# Azure

## Prod Environment

### Platform

* App : PHP
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx

#### Linux : [Ubuntu Server](https://ubuntu.com/download/server/arm)

* Connect Instance - [Document](https://guide.ncloud-docs.com/docs/ko/server-overview)

```
sudo chmod 400 "${KEY_PATH}/{your name}.pem"

ssh -i "${KEY_PATH}/{your name}.pem/${KEY_NAME}" root@"{HOST}"
```

* User - adduser : ubuntu

```
sudo adduser --home /home/ubuntu --uid 2000 --shell /bin/bash ubuntu

sudo usermod -aG sudo ubuntu
sudo usermod -aG www-data ubuntu
```

```
sudo chage -m 3 -M 100 -W 60 -I 30 -E 2099-12-30 ubuntu

sudo grep ubuntu /etc/shadow
sudo grep ubuntu /etc/passwd

sudo chage -l ubuntu
```

```
sudo vi /etc/sudoers.d/ubuntu

# User privilege specification
ubuntu  ALL=(ALL:ALL) NOPASSWD:ALL
```

* User - userdel : ubuntu

```
sudo userdel -r ubuntu
```

* Group - addgroup : ncloud

```
sudo addgroup --gid 3000 ncloud

sudo grep ncloud /etc/group
```

```
sudo gpasswd -a ubuntu ncloud
```

* Group - groupdel : ncloud

```
sudo gpasswd -r ncloud
```

### Project

* Create SSH Key for [SourceCommit](https://guide.ncloud-docs.com/docs/ko/sourcecommit-use-client)

```
ryan.lim@gram:~$ ssh-keygen -f id_sourcecommit -t rsa -b 2048
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in id_sourcecommit
Your public key has been saved in id_sourcecommit.pub
The key fingerprint is:
SHA256:zSc6aoecGQlmDx7k+OwS/3u9LgTFpvhi1VRH9U2Q0lk ryan.lim@gram
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
ryan.lim@gram:~$ 
ryan.lim@gram:~$ cat /home/ryan.lim/.ssh/id_sourcecommit.pub

```

* Update default variables in Prod Environment

```
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

### App

#### Symfony Framework

* Update packages

```
cd ~/Downloads

sudo apt update -y
sudo apt install -y curl git wget unzip
sudo apt autoremove -y
```

* Work Directory

```
sudo mkdir -p /var/www
sudo mkdir -p /var/www/github
sudo chown -R "${LOGNAME}":"${LOGNAME}" /var/www/github

cd /var/www/github && if [ -d symfony ]; then rm -rf symfony ; fi
```

* Download this project

```
git clone https://github.com/xsuntel/symfony-scripts.git symfony

cd symfony && find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

* Deploy this project

```
./scripts/cloud/azure/instance/deploy.sh
```

### Database

#### PostgreSQL

* Configure databases

```
./tools/ide/migrate.sh
```

## Reference

### Server

* Cloud
    * Azure