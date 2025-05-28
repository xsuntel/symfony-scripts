# Dev Environment

## Platform

* Linux - Ubuntu Desktop

### System

#### Module

* Update Kernel - /etc/modprobe.d/blacklist.conf

```bash
lsmod

modprobe -c
```

```bash
sudo vi /etc/modprobe.d/blacklist.conf
~
# Customize - Mainboard ACPI
blacklist acpi_thermal_rel
blacklist int3403_thermal
blacklist i801_smbus
blacklist lp

# Customize - Network - WiFi
blacklist iwlwifi

# Customize - Bluetooth
blacklist Bluetooth

sudo dpkg-reconfigure linux-image-$(uname -r)
```

* Update Kernel - /etc/apparmor.d/
  * <https://documentation.ubuntu.com/server/how-to/security/apparmor/index.html>

```bash
sudo aa-status

cd /etc/apparmor.d/ 

journalctl -k | grep apparmor
```

* Update Kernel - /etc/apparmor.d/
  * <https://documentation.ubuntu.com/server/how-to/security/apparmor/index.html>

```bash
sudo aa-status

cd /etc/apparmor.d/ 

journalctl -k | grep apparmor
```

#### Network

* Disable Bluetooth

```bash
sudo systemctl disable bluetooth
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

## Reference

### Hardware - Laptop - LG Gram

* Remove firmware

```bash
sudo apt remove -y fwupd

sudo userdel fwupd-refresh
```

* Remove error message

```bash
sudo modprobe -r int3403_thermal

sudo vi /etc/modprobe.d/blacklist.conf
~
blacklist int3403_thermal
```
