# Office - Desktop - Linux - Ubuntu Desktop

## Prod Environment

### Platform - Linux : [Ubuntu Desktop](https://ubuntu.com/desktop)

* App : PHP
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx
* Tools

### Project

* Update default variables in Prod Environment

```
vi .env.prod

# ======================================================================================================================
# Symfony Framework - Prod Environment                                   https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> Cache
REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# >>>> Database
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432
POSTGRES_DB=company
POSTGRES_USER=symfony
POSTGRES_PASSWORD=!ChangeMe!

# >>>> Messenger
RABBITMQ_VERSION=3
RABBITMQ_HOST=127.0.0.1
RABBITMQ_PORT=5672

# >>>> Server
NGINX_HOST=127.0.0.1
NGINX_PORT=80
```

### App

#### Symfony Framework

* Deploy this project

```
./scripts/cloud/office/desktop/deploy.sh
```

### Database

#### PostgreSQL

* Configure the database

```
[root@localhost] sudo -i -u postgres
[sudo] password for user: {password}

postgres@localhost:~$ psql
psql (xx.y)
Type "help" for help.

postgres=# create user symfony password '!ChangeMe!' superuser;
CREATE ROLE
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of 
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 symfony   | Superuser                                                  | {}

postgres=# \q

```

* Change the user's password

```
sudo -i -u postgres
[sudo] password for user: {password}

postgres@localhost:~$ psql
psql (xx.y)
Type "help" for help.

postgres=# alter user {user_name} password {user_password}

postgres=# \q

```

* Configure databases

```
./tools/ide/migrate.sh
```

### Virtual Machine

* TimeZone
```
sudo timedatectl set-timezone 'Asia/Seoul'

date
```

* User
  * Settings / System / Users / Automatic Login : Enable

```
sudo cat /etc/passwd

# Login ID : x : UID : GID : Description : Home Directory : Login Shell

sudo userdel mail
sudo userdel proxy
sudo userdel irc
```

* SSH Key Agent
```
gnome-keyring-daemon --components keyring,pkcs11
```

* Configure Firewall

```
sudo vi /etc/default/ufw

IPV6=no
```

```
sudo vi /etc/ufw/before.rules

# ok icmp codes for INPUT
-A ufw-before-input -p icmp --icmp-type destination-unreachable -j DROP
-A ufw-before-input -p icmp --icmp-type time-exceeded -j DROP
-A ufw-before-input -p icmp --icmp-type parameter-problem -j DROP
-A ufw-before-input -p icmp --icmp-type echo-request -j DROP
```

* Configure Network Manager

```
sudo vi /etc/netplan/01-network-manager-all.yaml 

network:
  version: 2
  renderer: NetworkManager
  ethernets:
    {ethernet name}:
      dhcp4: yes
      dhcp6: no
    wlp0s20f3:
      dhcp4: yes
      dhcp6: no
```

* Configure hosts

```
sudo vi /etc/hosts 
```

* Configure dns

```
resolvectl status

sudo vi /etc/resolv.conf 
```

```
netstat -plnt  
```

#### Wireless

* Configure a device

```
nmcli device

nmcli device wifi list

nmcli device wifi connect {SSID} password {PASSWORD}

nmcli device
```

#### VPN : NordVPN

* Install NordVPN on Linux

```
sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
```

```
sudo usermod -aG nordvpn $USER
```

* Login NordVPN

```
nordvpn login
nordvpn countries
nordvpn connect {country_name}
nordvpn status
nordvpn settings
```

* Using Meshnet on Linux

```
nordvpn set autoconnect on

nordvpn set dns 8.8.8.8 8.8.4.4

nordvpn set meshnet on
nordvpn meshnet peer list
```

* Disable virtual-location on Linux

```
nordvpn set virtual-location disable
```

#### ClamShell Mode

* Modify a configuration

```
sudo vi /etc/systemd/logind.conf

HandleLidSwitch=ignore

sudo service systemd-logind restart
```

```
sudo reboot
```

## Reference

* Linux - Ubuntu
  * [Ubuntu Server](https://ubuntu.com/server)
  * [Ubuntu Desktop](https://ubuntu.com/desktop)

* NordVPN
  * [Installing NordVPN on Linux](https://support.nordvpn.com/hc/en-us/articles/20196094470929-Installing-NordVPN-on-Linux-distributions) 
  * [Using Meshnet on Linux](https://meshnet.nordvpn.com/getting-started/how-to-start-using-meshnet/using-meshnet-on-linux)
  * [Connect to a Linux device](https://meshnet.nordvpn.com/how-to/remote-access/log-in-to-pc-remotely/connect-to-linux) 

