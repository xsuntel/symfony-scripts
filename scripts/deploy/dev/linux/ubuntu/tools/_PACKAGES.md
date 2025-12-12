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

* Update Kernel - /etc/apparmor.d/
    * <https://documentation.ubuntu.com/server/how-to/security/apparmor/index.html>

```bash
sudo aa-status

cd /etc/apparmor.d/ 

journalctl -k | grep apparmor
```

#### User

* User

```bash
sudo cat /etc/shadow

# Login ID : User Password : Last changed data : MIN : MAX : WARNING : INACTIVE : EXPIRE : Flag
```

```bash
sudo lastlog -b 90
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

* Services

```bash
/usr/bin/systemd-sysusers --cat-config
```

### Packages

#### snap

* Update snap-store

```bash
sudo killall snap-store

sudo snap refresh
```

#### gsd

* Disable gsd-sharing

```bash
sudo vi /etc/xdg/autostart/org.gnome.SettingsDaemon.Sharing.desktop
~
X-GNOME-Autostart-Phase=false
X-GNOME-Autostart-Notify=false
X-GNOME-AutoRestart=false

systemctl --user status org.gnome.SettingsDaemon.Sharing.service

systemctl --user mask org.gnome.SettingsDaemon.Sharing.service
```

* Disable gsd-smartcard

```bash
sudo vi /etc/xdg/autostart/org.gnome.SettingsDaemon.Smartcard.desktop
~
X-GNOME-Autostart-Phase=false
X-GNOME-Autostart-Notify=false
X-GNOME-AutoRestart=false

systemctl --user mask org.gnome.SettingsDaemon.Smartcard.service
```

* Disable gsd-wacom

```bash
sudo vi /etc/xdg/autostart/org.gnome.SettingsDaemon.Wacom.desktop
~
X-GNOME-Autostart-Phase=false
X-GNOME-Autostart-Notify=false
X-GNOME-AutoRestart=false

systemctl --user mask org.gnome.SettingsDaemon.Wacom.service
```

## Reference

### Hardware - Laptop - LG Gram

* Remove error message

```bash
sudo modprobe -r int3403_thermal

sudo vi /etc/modprobe.d/blacklist.conf
~
blacklist int3403_thermal
```
