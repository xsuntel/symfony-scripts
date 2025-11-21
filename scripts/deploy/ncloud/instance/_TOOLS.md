# Scripts - Public Cloud - NCloud

## Environment - Prod

## Platform

* Linux : [Ubuntu Server](https://ubuntu.com/download/server/)
    * App : PHP
    * Cache : Redis
    * Database : PostgreSQL
    * Message : RabbitMQ
    * Server : Nginx

### Server

* User - adduser : ubuntu

```bash
sudo vi /etc/sudoers.d/ubuntu

# User privilege specification
ubuntu  ALL=(ALL:ALL) NOPASSWD:ALL
```

* User - userdel : ubuntu

```bash
sudo userdel -r ubuntu
```

* Group - groupdel : ncloud

```bash
sudo gpasswd -r ncloud
```

## Reference

### Server

* Cloud
    * NCloud (Naver Cloud Platform)
    * Solution
        * [WebHosting](https://www.ncloud.com/solution/type/webHosting)
    * System
        * Compute
            * [Server](https://www.ncloud.com/product/compute/server)
        * Developer Tools
            * [SourceCommit](https://guide.ncloud-docs.com/docs/ko/sourcecommit-use-client)
