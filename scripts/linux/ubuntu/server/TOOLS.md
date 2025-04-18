# Dev Environment

## Platform

* Linux - Ubuntu Desktop

### System

* Update umask

```
sudo vi /etc/profile
~
TMOUT=600
export TMOUT

umask 022
export umask
```

```
sudo vi ~/.bashrc
~
umask 022
```

* Update Kernel - /etc/sysctl.conf

```
sudo vi /etc/sysctl.conf 
~
# CPU
kernel.perf_cpu_time_max_percent = 25
kernel.perf_event_max_sample_rate = 10000


# Network - ipv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

net.ipv4.icmp_echo_ignore_all = 1

# Sandbox
kernel.apparmor_restrict_unprivileged_unconfined=1
kernel.apparmor_restrict_unprivileged_userns=1

kernel.apparmor_restrict_unprivileged_userns_complain=1
kernel.apparmor_restrict_unprivileged_userns_force=1

kernel.unprivileged_userns_apparmor_policy=0
kernel.unprivileged_userns_clone=0

sudo cat /etc/sysctl.conf 

sudo sysctl -a | grep userns

sudo ls -ltr /proc/sys/kernel

sudo dmesg | tail -n 100

```

* Update Kernel - /etc/apparmor.d/

```
cd /etc/apparmor.d/ 


journalctl -k | grep apparmor
```

### Network


* Update Kernel - /etc/default/grub

```
sudo vi /etc/default/grub
~
GRUB_CMDLINE_LINUX="ipv6.disable=1 crashkernel=no net.ifnames=0 biosdevname=0"

sudo update-grub
```

* Update Kernel - /etc/modprobe.d/blacklist.conf

```
sudo vi /etc/modprobe.d/blacklist.conf
~
# Disable IPv6
blacklist ipv6

sudo dpkg-reconfigure linux-image-$(uname -r)
```

* Update Kernel - /etc/sysctl.d/10-ipv6-privacy.conf

```
sudo vi /etc/sysctl.d/10-ipv6-privacy.conf

net.ipv6.conf.all.use_tempaddr = 0
net.ipv6.conf.default.use_tempaddr = 0
```

#### User

* User

```
sudo cat /etc/passwd

# Login ID : x : UID : GID : Description : Home Directory : Login Shell

sudo userdel fwupd-refresh
sudo userdel tss

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

sudo vi /usr/lib/sysusers.d/basic.conf
~

u sync       4:65534 - /bin                 /bin/sync
u games      5:60    - /usr/games           /usr/sbin/nologin
u lp         7       - /var/spool/lpd       /usr/sbin/nologin

u news       9       - /var/spool/news      /usr/sbin/nologin
u uucp       10      - /var/spool/uucp      /usr/sbin/nologin

u irc        39      - /run/ircd            /usr/sbin/nologin
```

```
sudo rm -f /etc/init.d/cups

sudo rm -f /etc/init.d/speech-dispatcher

sudo rm -f /etc/init.d/uuidd

sudo rm -f /etc/init.d/apache-htcacheclean

sudo rm -f /etc/init.d/apache2
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

#### Remote

* Update ssh

```
sudo vi /etc/ssh/sshd_config
~
PermitRootLogin no
```

* Update cron

```
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
#17 *	* * *	root	cd / && run-parts --report /etc/cron.hourly
#25 6	* * *	root	test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.daily; }
#47 6	* * 7	root	test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.weekly; }
#52 6	1 * *	root	test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.monthly; }
```

#### Services

* Disable NFS

```
ps -ef | egrep "nfs|statd|lockd"
root 3809 3721 0 08:44:40 ? 0:00 /usr/lib/nfs/nfsd

sudo kill -9 3809
```

### Packages

* Update snap-store

```
sudo killall snap-store

sudo snap refresh
```

```
sudo mkdir -p ~/.config/autostart

```

* Disable gsd-sharing

```
sudo vi /etc/xdg/autostart/org.gnome.SettingsDaemon.Sharing.desktop
~
X-GNOME-Autostart-Phase=false
X-GNOME-Autostart-Notify=false
X-GNOME-AutoRestart=false

systemctl --user status org.gnome.SettingsDaemon.Sharing.service
```

* Disable gsd-smartcard

```
sudo vi /etc/xdg/autostart/org.gnome.SettingsDaemon.Smartcard.desktop
~
X-GNOME-Autostart-Phase=false
X-GNOME-Autostart-Notify=false
X-GNOME-AutoRestart=false
```

* Disable gsd-wacom

```
sudo vi /etc/xdg/autostart/org.gnome.SettingsDaemon.Wacom.desktop
~
X-GNOME-Autostart-Phase=false
X-GNOME-Autostart-Notify=false
X-GNOME-AutoRestart=false
```

* Disable snapd-desktop-integration

```
sudo snap remove --purge snapd-desktop-integration
```


## Reference

### Hardware - Laptop - LG Gram

* Remove firmware

```
sudo apt remove -y fwupd

sudo userdel fwupd-refresh
sudo userdel tts
```

* Remove error message

```
sudo modprobe -r int3403_thermal

sudo vi /etc/modprobe.d/blacklist.conf
~
blacklist int3403_thermal
```

```
sudo vi /etc/default/grub
~
CRUB_CMDLINE_LINUX_DEFAULT="quiet splash pci=nommconf"

sudo update-grub
```

### Tools

* Symfony             - [Console Commands](https://symfony.com/doc/current/console.html)
