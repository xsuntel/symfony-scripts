# Ubuntu

This project includes some shell-scripts to develop a web application using Symfony Framework

## Abstract

* App (PHP) + Cache (Redis) + Database (PostgreSQL) + Server (Nginx)

## Dev Environment

### Platform

* Linux - Ubuntu Desktop

#### Ubuntu

* User

```
sudo cat /etc/passwd

# Login ID : x : UID : GID : Description : Home Directory : Login Shell

sudo userdel lp
sudo userdel sync
sudo userdel games
sudo userdel uucp
sudo userdel news
sudo userdel tcpdump

sudo userdel adm
sudo userdel shutdown
sudo userdel halt
sudo userdel operator
sudo userdel gopher
sudo userdel nfsnobody
sudo userdel squid
sudo userdel gnome-remote-desktop

sudo vi /usr/lib/sysusers.d/basic.conf
u sync       4:65534 - /bin                 /bin/sync
u games      5:60    - /usr/games           /usr/sbin/nologin
u lp         7       - /var/spool/lpd       /usr/sbin/nologin
u news       9       - /var/spool/news      /usr/sbin/nologin
u uucp       10      - /var/spool/uucp      /usr/sbin/nologin

```

```
sudo cat /etc/shadow

# Login ID : User Password : Last changed data : MIN : MAX : WARNING : INACTIVE : EXPIRE : Flag
```

```
sudo lastlog -b 90
```

* Group

```
sudo cat /etc/group

# Group Name : x : GID : Group Members
```

```
sudo cat /etc/gshadow

# Group Name : Group Password : Administrator : Group Members
```

* Services
```
/usr/bin/systemd-sysusers --cat-config
```

### Tools

#### Ubuntu Desktop

* Update packages in Dev Environment

```
./scripts/linux/ubuntu/server/local.sh
```
