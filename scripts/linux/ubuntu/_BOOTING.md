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

#sudo ebtables -F

# ------------------------------------------------------------------------------------------------------------------
# Mobile - Personal
# ------------------------------------------------------------------------------------------------------------------

#sudo ebtables -A INPUT -s xx:xx:xx:xx:xx:xx -j DROP


# ------------------------------------------------------------------------------------------------------------------
# Laptop - Company
# ------------------------------------------------------------------------------------------------------------------

#sudo ebtables -A INPUT -s xx:xx:xx:xx:xx:xx -j DROP

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
