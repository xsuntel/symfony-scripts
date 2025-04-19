#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Network
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Operating System"
    echo

    local addPackageList="ufw"
    for pkgItem in ${addPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
        sudo apt install -y ${pkgItem}
        sudo systemctl enable ${pkgItem}
        sudo systemctl start ${pkgItem}
        echo
      fi
    done

    # >>>> Stop the process
    local UFW_STATUS
    UFW_STATUS=$(systemctl is-active ufw)
    if [ "${UFW_STATUS}" == "active" ]; then
      sudo ufw logging off
      sudo ufw disable
    fi

    # >>>> Reset current rules
    sudo ufw --force reset
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - default
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Incoming
    sudo ufw default deny incoming
    # >>>> Outgoing
    sudo ufw default allow outgoing
    # >>>> Logging
    sudo ufw logging on
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - incoming
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Update allowed services
    sudo ufw allow domain comment "DNS"
    sudo ufw allow ntp comment 'NTP'

    # >>>> Update allowed ports for App      - PHP
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9001 proto tcp comment 'PHP - Xdebug - DBGp Proxy'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9003 proto tcp comment 'PHP - Xdebug'

      # >>>> Symfony Local Server
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8000 proto tcp comment 'Local server - 00'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8010 proto tcp comment 'Local server - 10'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8020 proto tcp comment 'Local server - 20'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8030 proto tcp comment 'Local server - 30'
    fi

    # >>>> Update allowed ports for Cache    - Redis
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 6379 proto tcp comment 'Redis'
    else
      sudo ufw allow 6379/tcp comment 'Redis'
    fi

    # >>>> Update allowed ports for Database - PostgreSQL
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5432 proto tcp comment 'PostgreSQL'
    else
      sudo ufw allow 5432/tcp comment 'PostgreSQL'
    fi

    # >>>> Update allowed ports for Message  - RabbitMQ
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5672 proto tcp comment 'RabbitMQ'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 15672 proto tcp comment 'RabbitMQ - UI'
    else
      sudo ufw allow 5672/tcp comment 'RabbitMQ'
    fi

    # >>>> Update allowed ports for Server   - Nginx
    sudo ufw allow 80/tcp  comment 'Nginx - HTTP'
    sudo ufw allow 443/tcp comment 'Nginx - HTTPS'

    # >>>> Update allowed ports for Tools    - Remote Desktop
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      #sudo ufw allow 3389/tcp comment 'Remote Desktop'
      #sudo ufw allow from 192.168.0.0/24 to 192.168.0.0/24 port 3389 proto tcp comment 'Remote Desktop'
      echo
    fi

    # >>>> Update deny network
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      #sudo ufw deny from 10.0.0.0/8
      #sudo ufw deny from 172.16.0.0/12
      #sudo ufw deny from 192.168.0.0/16
      #sudo ufw deny from 192.168.0.0/24
      echo
    fi

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - outgoing - well-known port
    # ------------------------------------------------------------------------------------------------------------------

    sudo ufw deny from any to any port 1 comment 'TCPMUX'
    sudo ufw deny from any to any port 7 comment 'ECHO'
    sudo ufw deny from any to any port 9 comment 'DISCARD'
    sudo ufw deny from any to any port 13 comment 'DAYTIME'
    sudo ufw deny from any to any port 17 comment 'QOTD'
    sudo ufw deny from any to any port 19 comment 'CHARGEN'

    sudo ufw deny from any to any port 20 comment 'FTP'
    sudo ufw deny from any to any port 21 comment 'FTP'
    sudo ufw deny from any to any port 22 comment 'SSH'
    sudo ufw deny from any to any port 23 comment 'Telnet'
    sudo ufw deny from any to any port 24 comment 'Mail'
    sudo ufw deny from any to any port 25 comment 'SMTP'

    sudo ufw deny from any to any port 37 comment 'TIME'
    sudo ufw deny from any to any port 49 comment 'TACACS'

    sudo ufw deny from any to any port 69 comment 'TFTP'
    sudo ufw deny from any to any port 70 comment 'Gopher'
    sudo ufw deny from any to any port 79 comment 'Finger'
    sudo ufw deny from any to any port 88 comment 'Kebelos'

    sudo ufw deny from any to any port 109 comment 'POP2'
    sudo ufw deny from any to any port 110 comment 'POP3'
    sudo ufw deny from any to any port 111 comment 'RPC'
    sudo ufw deny from any to any port 113 comment 'ident'
    sudo ufw deny from any to any port 119 comment 'NNTP'

    sudo ufw deny from any to any port 137 comment 'SMB'
    sudo ufw deny from any to any port 138 comment 'SMB'
    sudo ufw deny from any to any port 139 comment 'NetBIOS'
    sudo ufw deny from any to any port 143 comment 'IMAP4'
    sudo ufw deny from any to any port 161 comment 'SNMP'
    sudo ufw deny from any to any port 162 comment 'SNMP'
    sudo ufw deny from any to any port 220 comment 'IMAP3'
    sudo ufw deny from any to any port 389 comment 'LDAP'
    sudo ufw deny from any to any port 445 comment 'Active Directory'
    sudo ufw deny from any to any port 465 comment 'SMTP'
    sudo ufw deny from any to any port 514 comment 'Syslog'
    sudo ufw deny from any to any port 515 comment 'LPD'
    sudo ufw deny from any to any port 540 comment 'UUCP'
    sudo ufw deny from any to any port 542 comment 'RFC'
    sudo ufw deny from any to any port 587 comment 'SMTP'
    sudo ufw deny from any to any port 592 comment 'File Maker'
    sudo ufw deny from any to any port 631 comment 'Internet Print'
    sudo ufw deny from any to any port 636 comment 'LDAP'
    sudo ufw deny from any to any port 666 comment 'Game'
    sudo ufw deny from any to any port 873 comment 'Rsync'
    sudo ufw deny from any to any port 981 comment 'Firewall'
    sudo ufw deny from any to any port 990 comment 'FTP'
    sudo ufw deny from any to any port 992 comment 'Telnet'
    sudo ufw deny from any to any port 993 comment 'IMAP4'
    sudo ufw deny from any to any port 995 comment 'POP3'

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - outgoing - registered port
    # ------------------------------------------------------------------------------------------------------------------
    #for i in `seq 1024 1030`; do
    #  sudo ufw deny from any to any port $i comment 'registered port'
    #done

    sudo ufw deny from any to any port 1080 comment 'SOCKS'
    sudo ufw deny from any to any port 1900 comment 'SSDP'

    sudo ufw deny from any to any port 3283 comment 'Remote Desktop - RDP'
    sudo ufw deny from any to any port 3389 comment 'Remote Desktop - RDP'

    sudo ufw deny from any to any port 3479 comment 'Playstation'
    sudo ufw deny from any to any port 3480 comment 'Playstation'
    sudo ufw deny from any to any port 3690 comment 'Subversion'

    sudo ufw deny from any to any port 3390 comment 'Remote Desktop - RDP'

    sudo ufw deny from any to any port 5228 comment 'HP Virtual Room Service'
    sudo ufw deny from any to any port 5353 comment 'Multicast DNS'

    sudo ufw deny from any to any port 5590 comment 'Remote Desktop - MacOS'

    sudo ufw deny from any to any port 17500 comment 'Dropbox LanSync'

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - Enable
    # ------------------------------------------------------------------------------------------------------------------
    echo
    sudo ufw disable
    sudo ufw enable
    echo

    sudo ufw status verbose
    echo
fi
