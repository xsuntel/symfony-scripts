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

#### Network Manager

* Check NetworkManager

```bash
systemctl status NetworkManager
```

* Edit Interface

```bash
nm-connection-editor
```

```bash
nmcli con status
```

```bash
nmcli dev status

nmcli dev show
```

```bash
nmcli connection reload
```

##### IP Address

```bash
ip route show

ip addr show
```

#### WiFi

##### Disable

* Update Kernel - /etc/modprobe.d/blacklist.conf

```bash
lsmod

sudo vi /etc/modprobe.d/blacklist.conf
~

# Customize - Network - WiFi
blacklist iwlwifi

sudo dpkg-reconfigure linux-image-$(uname -r)
```

* Remove WiFi

```bash
sudo apt remove --purge wpasupplicant
```

#### Bluetooth

##### Command

* Check Mac Address

```bash
bluetoothctl

devices
```

* Block Mac Address

```bash
bluetoothctl

block XX:XX:XX:XX:XX:XX
```

* UnBlock Mac Address

```bash
bluetoothctl

unblock XX:XX:XX:XX:XX:XX
```

* Disable Bluetooth

```bash
sudo systemctl disable bluetooth
```

##### Disable

* Update Kernel - /etc/modprobe.d/blacklist.conf

```bash
lsmod

sudo vi /etc/modprobe.d/blacklist.conf
~

# Customize - Bluetooth
blacklist Bluetooth

sudo dpkg-reconfigure linux-image-$(uname -r)
```

* Disable Bluetooth

```bash
sudo systemctl disable bluetooth
```