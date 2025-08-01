#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Network
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Linux - Network"
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
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5672  proto tcp comment 'RabbitMQ'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5552  proto tcp comment 'RabbitMQ - stream'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 15672 proto tcp comment 'RabbitMQ - http'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 25672 proto tcp comment 'RabbitMQ - clustering'
    else
      sudo ufw allow 5672/tcp comment 'RabbitMQ'
      sudo ufw allow 5552/tcp comment 'RabbitMQ - stream'
    fi

    # >>>> Update allowed ports for Server   - Nginx
    sudo ufw allow http  comment 'Nginx - HTTP'
    sudo ufw allow https comment 'Nginx - HTTPS'

    # >>>> Update allowed ports for Tools    - Remote Desktop
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      #sudo ufw allow 3389/tcp comment 'Remote Desktop'
      #sudo ufw allow from 192.168.0.0/24 to 192.168.0.0/24 port 3389 proto tcp comment 'Remote Desktop'
      echo
    fi

    # >>>> Private Network - Inbound Traffic
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      sudo ufw deny from 10.0.0.0/8
      sudo ufw deny from 172.16.0.0/12
      #sudo ufw deny from 192.168.0.0/16
      #sudo ufw deny from 192.168.0.0/24
      sudo ufw deny from 192.168.55.0/24

    fi

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - Outgoing traffic
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Private Network - Outbound Traffic
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      sudo ufw deny from any to any port 1
      sudo ufw deny from any to any port 7
      sudo ufw deny from any to any port 9
      sudo ufw deny from any to any port 13
      sudo ufw deny from any to any port 17
      sudo ufw deny from any to any port 19
      sudo ufw deny from any to any port 20
      sudo ufw deny from any to any port 21
      sudo ufw deny from any to any port 23
      sudo ufw deny from any to any port 24
      sudo ufw deny from any to any port 69
      sudo ufw deny from any to any port 70
      sudo ufw deny from any to any port 161
      sudo ufw deny from any to any port 162
      sudo ufw deny from any to any port 445
      sudo ufw deny from any to any port 514
      sudo ufw deny from any to any port 515
      sudo ufw deny from any to any port 540
      sudo ufw deny from any to any port 542
      sudo ufw deny from any to any port 591
      sudo ufw deny from any to any port 636
      sudo ufw deny from any to any port 873
      sudo ufw deny from any to any port 981
      sudo ufw deny from any to any port 990
      sudo ufw deny from any to any port 992
      sudo ufw deny from any to any port 1080
      sudo ufw deny from any to any port 1900
      sudo ufw deny from any to any port 3690
      sudo ufw deny from any to any port 4369
      sudo ufw deny from any to any port 5228
      sudo ufw deny from any to any port 5551
      sudo ufw deny from any to any port 5552
      sudo ufw deny from any to any port 17500
    fi

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
