# Tools - IDE

## Abstract

This project includes some scripts to develop a web application using Symfony Framework

## Platform

* Linux
* MacOS
* Windows

## Project

### Website

* App
  * {your_domain}

* Blog
  * blog.{your_domain}

* YouTube
  * youtube.{your_domain}

* GitHub
  * github.{your_domain}

* Store
  * store.{your_domain}

### Email

* Product
  * product@{your_domain}

* Support
  * support@{your_domain}
  * help@{your_domain}
  * info@{your_domain}
  * cs@{your_domain}

* privacy
  * privacy@{your_domain}

* recruit
  * recruit@{your_domain}

* Ads
  * service@{your_domain}

## Tools

### Network Ports

* Linux

TCP 20 ~ 24       / FTP
TCP 22            / SSH
TCP 25            / SMTP

UDP 137,138       / SMB
TCP 139,445       / SMB

UDP 161, 162      / SNMP

UDP 500           / VPN
UDP 4500          / VPN

TCP 1028          / Trojan
TCP 1032          / Trojan Microsoft Outlook. Akosch4, Dosh, ICQ , KWM

TCP 1433          / SQL

TCP 3389          / MySQL
TCP 5432          / PostgreSQL

TCP 6379          / Redis

* Windows - Remote Desktop

TCP 3389~3390     / Remote

* MacOS   - Remote Desktop

TCP 5900          / Control and observe
UDP 5900          / Send screen, share screen

TCP 3283          / Reporting
UDP 3283          / Additional data

* Services

TCP 49664~49667   / Spooler Skype

tcp 6969,6970,7000,1027,7789,9989,10520

* Virus

TCP 111     / SunRPC

TCP 135     / Blaster
UDP 135     / Blaster

TCP 139     / Welchia

TCP 445     / Agobot

TCP 1025    / Dasher
UDP 1025    / Dasher

TCP 1080    / MyDoom
UDP 1080    / MyDoom

TCP 1433    / Spida
UDP 1433    / Spida

TCP 1434    / SQL Slammer

TCP 2745    / Bagle

TCP 3127    / MyDoom

TCP 3410    / Optixpro

TCP 4899    / RAdmin

TCP 5000    / Bodax
UDP 5000    / Bodax

TCP 6000    / X-Windows

TCP 6129    / Mockbot

TCP 6667    / IRCBot

TCP 9898    / Dabber

TCP 9996    / Sassor

TCP 65520   / Virut


### IDE - PhpStorm

#### Settings

* Disable some configurations

```
Settings / Appearance & Behavior / System Settings / Autosave / Sync external changes: 


Settings / Appearance & Behavior / System Settings / HTTP Proxy
```

#### Menu / Help

* Edit Custom Properties

```
idea.max.content.load.filesize=40000
idea.max.intellisense.filesize=10000
idea.cycle.buffer.size=2048

idea.max.vcs.loaded.size.kb=40960

idea.no.launcher=false
idea.dynamic.classpath=false

editor.zero.latency.typing=true
```

* Edit Custom VM Options

```
-Xmx4G
-Xms2G
-XX:NewRatio=4
```

## Reference

### Public Cloud

* AWS
  * [Elastic Beanstalk](https://aws.amazon.com/ko/elasticbeanstalk)
  * [Lightsail](https://aws.amazon.com/ko/lightsail)

* NCloud
  * Solution - [WebHosting](https://www.ncloud.com/solution/type/webHosting)

### Tools

* WiKi - [TCP/UDP Port List](https://ko.wikipedia.org/wiki/TCP/UDP%EC%9D%98_%ED%8F%AC%ED%8A%B8_%EB%AA%A9%EB%A1%9D)

* Draw.io             - [Download](https://drawio.com/)

* IDE
  * [PhpStorm](https://www.jetbrains.com/phpstorm)
    * Settings
      * PHP
        * Xdebug - [Configuration](https://www.jetbrains.com/help/phpstorm/debugging-with-phpstorm-ultimate-guide.html)
      * Deployment - [Deploying application](https://www.jetbrains.com/help/phpstorm/deploying-applications.html)
      * [Symfony Framework](https://www.jetbrains.com/help/phpstorm/symfony-support.html#use_symfony_cli)
    * Plugin
      * draw.io - [Integration](https://plugins.jetbrains.com/plugin/15635-diagrams-net-integration)