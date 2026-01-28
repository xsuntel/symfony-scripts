# Dev Environment

## Platform

* Linux - Ubuntu Desktop

## Project

* Check status

```bash
sudo systemctl status cron
```

* Modify crontab

```bash
sudo vi /etc/crontab
~
01 02 15 * * root /root/backup.sh
```

* Create a shell-script

```bash
cd /root
touch backup.sh
chmod 755 backup.sh
ls -l backup.sh
```

* Modify the shell-script

```bash
sudo vi ./backup.sh

#!/bin/bash
set $(date)
file_name="backup-$1$2$3tar.xz"
tar cfj /home/$USER/ /home
```

* Crete a directory for backup

```bash
mkdir -p /raid6/backup

sudo systemctl restart cron
```

* Test cron

```bash
timedatectl set-ntp 0

date 011502002026

sudo systemctl restart cron

ls -l /raid6/backup/
```

```bash
timedatectl set-ntp 1
```
