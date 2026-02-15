# Dev Environment

## Platform

* Linux - Ubuntu Desktop

### System

#### Boot Up

* Update a file : /etc/rc.local

```bash
sudo vi /etc/rc.local
~
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
