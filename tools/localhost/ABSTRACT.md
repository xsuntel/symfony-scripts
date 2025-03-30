# Tools - Localhost

## Abstract

## Platform

### Linux - Ubuntu Desktop 24.04 LTS

#### Packages

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
```

* Disable [Tracker3](https://www.linuxuprising.com/2019/07/how-to-completely-disable-tracker.html)

```
tracker3 daemon stop
tracker3 daemon --kill
tracker3 reset --filesystem

sudo apt remove tracker tracker-extract tracker-miner-fs
systemctl --user mask tracker-extract-3.service tracker-miner-fs-3.service tracker-miner-rss-3.service tracker-writeback-3.service tracker-xdg-portal-3.service tracker-miner-fs-control-3.service
tracker3 reset -s -r
```

```
cd /etc/xdg/autostart


sudo vi tracker-miner-fs-3.desktop
~
X-GNOME-Autostart-enabled=false


sudo cp /etc/xdg/autostart/tracker-miner-fs-3.desktop ~/.config/autostart/
sudo sed -i -e '$aX-GNOME-Autostart-enabled=false' ~/.config/autostart/tracker-miner-fs-3.desktop
```

### MacOS


### Windows


## Project

### Local Server

* Update localhost

```
./tools/ide/hosts.sh
```

* Update security rules for Firewall

```
./tools/ide/network.sh
```

* Update packages

```
./tools/ide/packages.sh
```

## Reference

### Tools

* Symfony             - [Console Commands](https://symfony.com/doc/current/console.html)
