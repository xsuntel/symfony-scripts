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

sudo ebtables -F

# >>>> Network - Firewall - IPv6

sudo ebtables -A FORWARD -p IPv6 -j DROP
sudo ebtables -A FORWARD -p ARP -j DROP
sudo ebtables -A FORWARD -p LENGTH -j DROP

sudo ebtables -A INPUT -p IPv6 -j DROP
sudo ebtables -A INPUT -p ARP -j DROP
sudo ebtables -A INPUT -p LENGTH -j DROP
 
sudo ebtables -A OUTPUT -p IPv6 -j DROP
sudo ebtables -A OUTPUT -p ARP -j DROP
sudo ebtables -A OUTPUT -p LENGTH -j DROP

# >>>> Network - Firewall - IPv4

sudo ebtables -A INPUT -p icmp --icmp-type echo-request -j DROP

# ------------------------------------------------------------------------------------------------------------------
# Devices
# ------------------------------------------------------------------------------------------------------------------

#sudo ebtables -A INPUT -s xx:xx:xx:xx:xx:xx -j DROP

#sudo ebtables -A FORWARD -s xx:xx:xx:xx:xx:xx -j DROP

#sudo ebtables -A OUTPUT -d xx:xx:xx:xx:xx:xx -j DROP

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
