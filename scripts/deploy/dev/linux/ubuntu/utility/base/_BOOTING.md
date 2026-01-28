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

#### BOOTING

* Update a file : /etc/rc.local

```bash
sudo vi /etc/rc.local


#!/bin/bash

# ----------------------------------------------------------------------------------------------------------------------
# START
# ----------------------------------------------------------------------------------------------------------------------

# >>>> TimeZone
local TIMDATECTL_STATUS
TIMDATECTL_STATUS=$(systemctl is-active systemd-timesyncd)
if [ "${TIMDATECTL_STATUS}" == "inactive" ]; then
  sudo timedatectl set-ntp true
  sudo systemctl start systemd-timesyncd
fi

# ----------------------------------------------------------------------------------------------------------------------
# Network - Firewall
# ----------------------------------------------------------------------------------------------------------------------

# >>>>  Linux - Network - Firewall

local addPackageList="ufw ebtables"
for pkgItem in ${addPackageList}; do
  local APT_PKG_INFO
  APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
  if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
    sudo apt install -y "${pkgItem}"
    sudo systemctl enable "${pkgItem}"
    sudo systemctl start "${pkgItem}"
    echo
  fi
done

sudo ebtables -F

# >>>> Network - Firewall - IPv6

sudo ebtables -A INPUT -p IPv6 -j DROP
sudo ebtables -A FORWARD -p IPv6 -j DROP
sudo ebtables -A OUTPUT -p IPv6 -j DROP

# >>>> Network - Firewall - IPv4

sudo ebtables -A INPUT -p icmp --icmp-type echo-request -j DROP

# >>>> Network - Firewall - Devices

#sudo ebtables -A INPUT -s xx:xx:xx:xx:xx:xx -j DROP
#sudo ebtables -A FORWARD -s xx:xx:xx:xx:xx:xx -j DROP
#sudo ebtables -A OUTPUT -d xx:xx:xx:xx:xx:xx -j DROP

# ----------------------------------------------------------------------------------------------------------------------
# Directory
# ----------------------------------------------------------------------------------------------------------------------

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

# ----------------------------------------------------------------------------------------------------------------------
# Crontab
# ----------------------------------------------------------------------------------------------------------------------

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

# ----------------------------------------------------------------------------------------------------------------------
# END
# ----------------------------------------------------------------------------------------------------------------------

exit 0
```

```bash
sudo chmod +x /etc/rc.local

sudo systemctl status rc-local.service
```

```bash
sudo vi /lib/systemd/system/rc-local.service
~

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable rc-local.service

sudo systemctl start rc-local.service
```
