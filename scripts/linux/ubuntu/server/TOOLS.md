# Dev Environment

## Platform

* Linux - Ubuntu Desktop

### Ubuntu Desktop

* Update umask

```
sudo vi /etc/profile
~
umask 022

export umask
```

```
sudo vi ~/.bashrc
~
umask 022
```

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
cd /etc/xdg/autostart

sudo vi org.gnome.SettingsDaemon.Sharing.desktop
~
X-GNOME-Autostart-Phase=false
X-GNOME-Autostart-Notify=false
X-GNOME-AutoRestart=false

sudo cp /etc/xdg/autostart/org.gnome.SettingsDaemon.Sharing.desktop ~/.config/autostart/
sudo sed -i -e '$aX-GNOME-Autostart-enabled=false' ~/.config/autostart/org.gnome.SettingsDaemon.Sharing.desktop

sudo sed -i -e '$aX-GNOME-Autostart-enabled=false' /etc/xdg/autostart/org.gnome.SettingsDaemon.Sharing.desktop

```

* Disable gsd-smartcard

```
cd /etc/xdg/autostart

sudo vi org.gnome.SettingsDaemon.Smartcard.desktop
~
X-GNOME-Autostart-Phase=false
X-GNOME-Autostart-Notify=false
X-GNOME-AutoRestart=false

sudo cp /etc/xdg/autostart/org.gnome.SettingsDaemon.Smartcard.desktop ~/.config/autostart/
sudo sed -i -e '$aX-GNOME-Autostart-enabled=false' ~/.config/autostart/org.gnome.SettingsDaemon.Smartcard.desktop

sudo sed -i -e '$aX-GNOME-Autostart-enabled=false' /etc/xdg/autostart/org.gnome.SettingsDaemon.Smartcard.desktop
```

* Disable gsd-wacom

```
cd /etc/xdg/autostart


sudo vi org.gnome.SettingsDaemon.Wacom.desktop
~
X-GNOME-Autostart-Phase=false
X-GNOME-Autostart-Notify=false
X-GNOME-AutoRestart=false

sudo cp /etc/xdg/autostart/org.gnome.SettingsDaemon.Wacom.desktop ~/.config/autostart/
sudo sed -i -e '$aX-GNOME-Autostart-enabled=false' ~/.config/autostart/org.gnome.SettingsDaemon.Wacom.desktop

sudo sed -i -e '$aX-GNOME-Autostart-enabled=false' /etc/xdg/autostart/org.gnome.SettingsDaemon.Wacom.desktop
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
