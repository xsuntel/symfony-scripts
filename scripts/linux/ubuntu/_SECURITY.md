# Scripts - Linux

## Environment - Dev

## Platform

* Linux - Ubuntu Desktop
  * App : PHP
  * Cache : Redis
  * Database : PostgreSQL
  * Message : RabbitMQ
  * Server : Nginx
  * Tools

### System

#### GRUB (Grand Unified Bootloader)

* Update Kernel - /etc/default/grub

```bash
sudo vi /etc/default/grub
~
GRUB_CMDLINE_LINUX="ipv6.disable=1 crashkernel=no net.ifnames=0 biosdevname=0"
CRUB_CMDLINE_LINUX_DEFAULT="quiet splash pci=nommconf"

sudo update-grub
```

#### Kernel

* Remove kerneloops

```bash
sudo systemctl stop kerneloops

sudo systemctl disable kerneloops
```

```bash
sudo systemctl stop sysstat

sudo systemctl disable sysstat
```

* Update Kernel - /etc/sysctl.conf

```bash
sudo vi /etc/sysctl.conf 
~

# Network - ipv6
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1

net.ipv6.conf.all.use_tempaddr=0
net.ipv6.conf.default.use_tempaddr=0

# Network - ipv4
net.ipv4.icmp_echo_ignore_all=1
```

```bash
sudo sysctl -a | grep userns

sudo ls -ltr /proc/sys/kernel

sudo dmesg | tail -n 100
```

#### Module

* Update Kernel - /etc/modprobe.d/blacklist.conf

```bash
lsmod

sudo vi /etc/modprobe.d/blacklist.conf
~
# Customize - Mainboard ACPI
blacklist acpi_thermal_rel
blacklist int3403_thermal
blacklist i801_smbus
blacklist lp

sudo dpkg-reconfigure linux-image-$(uname -r)
```

* Update Kernel - /etc/sysctl.d/10-ipv6-privacy.conf

```bash
sudo vi /etc/sysctl.d/10-ipv6-privacy.conf

net.ipv6.conf.all.use_tempaddr = 0
net.ipv6.conf.default.use_tempaddr = 0


netstat -lpn
```

#### Network

* Install etables

```bash
sudo apt-get install ebtables
```

```bash
sudo arp -a
```

```bash
sudo ebtables -F
```

```bash
sudo ebtables -A INPUT -s xx:xx:xx:xx:xx:xx -j DROP
```

```bash
sudo ebtables -D INPUT -s xx:xx:xx:xx:xx:xx -j DROP
```

```bash
sudo ebtables -L
```

#### Directories

* Update permission

```bash
sudo chown root:root /etc/sysctl.conf
sudo chmod 600 /etc/sysctl.conf
sudo ls -l /etc/sysctl.conf

sudo chown root:root /etc/hosts
sudo chmod 600 /etc/hosts
sudo ls -l /etc/hosts

sudo chown root:root /etc/passwd
sudo chmod 644 /etc/passwd
sudo ls -l /etc/passwd

sudo chown root:root /etc/shadow
sudo chmod 400 /etc/shadow
sudo ls -l /etc/shadow

sudo chown root:root /etc/rsyslog.conf
sudo chmod 640 /etc/rsyslog.conf
sudo ls -l /etc/rsyslog.conf

sudo chown root:root /etc/services
sudo chmod 644 /etc/services
sudo ls -l /etc/services

sudo chown root:root /etc/crontab
sudo chmod 640 /etc/crontab

sudo chown root:root /etc/cron.d/
sudo chmod 640 /etc/cron.d/

sudo chown root:root /etc/cron.daily/
sudo chmod 640 /etc/cron.daily/

sudo chown root:root /etc/cron.hourly/
sudo chmod 640 /etc/cron.hourly/

sudo chown root:root /etc/cron.monthly/
sudo chmod 640 /etc/cron.monthly/

sudo chown root:root /etc/cron.weekly/
sudo chmod 640 /etc/cron.weekly/

sudo chown root:root /etc/cron.yearly/
sudo chmod 640 /etc/cron.yearly/
```

* Update umask in Prod Environment

```bash
sudo vi /etc/profile
~
TMOUT=600
export TMOUT

umask 022
export umask
```

```bash
sudo vi ~/.bashrc
~
umask 022
```

#### User

* Modify passwd

```bash
sudo cat /etc/passwd

# Login ID : x : UID : GID : Description : Home Directory : Login Shell

sudo userdel fwupd-refresh
sudo userdel tss

sudo userdel list
sudo userdel lp
sudo userdel sync
sudo userdel games
sudo userdel uucp
sudo userdel uuidd
sudo userdel news
sudo userdel tcpdump

sudo userdel speech-dispatcher

sudo userdel adm
sudo userdel shutdown
sudo userdel halt
sudo userdel operator
sudo userdel gopher
sudo userdel nfsnobody
sudo userdel squid

sudo userdel tts

sudo vi /usr/lib/sysusers.d/basic.conf
~

u sync       4:65534 - /bin                 /bin/sync
u games      5:60    - /usr/games           /usr/sbin/nologin
u lp         7       - /var/spool/lpd       /usr/sbin/nologin

u news       9       - /var/spool/news      /usr/sbin/nologin
u uucp       10      - /var/spool/uucp      /usr/sbin/nologin

u irc        39      - /run/ircd            /usr/sbin/nologin

u list       38      - /var/list            /usr/sbin/nologin
```

```bash
sudo rm -f /etc/init.d/cups

sudo rm -f /etc/init.d/speech-dispatcher

sudo rm -f /etc/init.d/uuidd
```

#### Remote

* Update ssh

```bash
sudo vi /etc/ssh/sshd_config
~
PermitRootLogin no
```

#### Crontab

* Update cron

```bash
sudo chown root:root /etc/crontab  
sudo chmod 640 /etc/crontab 

sudo chown root:root /etc/cron.d/
sudo chmod 640 /etc/cron.d/ 
      
sudo chown root:root /etc/cron.daily/
sudo chmod 640 /etc/cron.daily/   

sudo chown root:root /etc/cron.hourly/
sudo chmod 640 /etc/cron.hourly/  

sudo chown root:root /etc/cron.monthly/
sudo chmod 640 /etc/cron.monthly/     

sudo chown root:root /etc/cron.weekly/
sudo chmod 640 /etc/cron.weekly/  

sudo chown root:root /etc/cron.yearly/
sudo chmod 640 /etc/cron.yearly/ 

sudo ls -l /etc/crontab

sudo vi /etc/crontab
~
#17 * * * * root cd / && run-parts --report /etc/cron.hourly
#25 6 * * * root test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.daily; }
#47 6 * * 7 root test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.weekly; }
#52 6 1 * * root test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.monthly; }
```

### Services

* Check services list

```bash
cat /etc/services

service --status-all
```

#### anacron

* Disable anacron

```bash
sudo vi /etc/anacrontab

# These replace cron's entries
#1      5       cron.daily      run-parts --report /etc/cron.daily
#7      10      cron.weekly     run-parts --report /etc/cron.weekly
#@monthly       15      cron.monthly    run-parts --report /etc/cron.monthly

sudo systemctl disable anacron
```

#### apport

* Disable apport

```bash
sudo vi /etc/default/apport
~
enabled=0

sudo systemctl disable apport
```

#### unattended-upgrades

* Disable unattended-upgrades

```bash
sudo systemctl disable unattended-upgrades

sudo apt remove --purge unattended-upgrades
```

## Reference

### Hardware - Laptop - LG Gram

* Remove firmware

```bash
sudo apt remove -y fwupd

sudo userdel fwupd-refresh
```