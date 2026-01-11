#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - Linux - Ubuntu - Network
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # Kernel
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Kernel
      echo ">>>> Linux - Kernel : $(uname -r)"
      echo

      sudo systemctl daemon-reload
      echo

      local NOW_KERNEL_VERSION=$(uname -r | cut -d '-' -f 1,2)
      local DEL_KERNEL_VERSION=$(dpkg --list | grep linux-image- |grep -v linux-image-${OLD_KERNEL_VERSION} | grep -v linux-image-generic-hwe |awk  '{print $2}')

      if [ ${DEL_KERNEL_VERSION} ]; then
        dpkg --list | grep linux-image
        echo

        echo "sudo apt-get purge -y ${DEL_KERNEL_VERSION} -f"
        echo
      fi

      # >>>> Kernel - Network - ipv4
      sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Hosts
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Hosts
      local PROJECT_HOST_NAME
      PROJECT_HOST_NAME=$(sudo grep -i "localhost" /etc/hosts | awk '{print $2}' | head -n 1)
      if [ ! "${PROJECT_HOST_NAME}" ]; then
        echo ">>>> Linux - Hosts"
        echo

        echo $'\n127.0.0.1 localhost' | sudo tee -a /etc/hosts
        echo

        sudo grep -v '#' /etc/hosts
        echo
      fi

      echo ">>>> Linux - Network - Firewall"
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # UFW
      # ----------------------------------------------------------------------------------------------------------------

      local addPackageList="ufw ebtables"
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

      local UFW_STATUS
      UFW_STATUS=$(systemctl is-active ufw)
      if [ "${UFW_STATUS}" == "active" ]; then
        sudo ufw logging off
        sudo ufw disable
      fi

      # >>>> Reset current rules
      sudo ufw --force reset
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # UFW - default
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Incoming
      sudo ufw default deny incoming
      # >>>> Outgoing
      sudo ufw default allow outgoing
      # >>>> Logging
      sudo ufw logging on
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # UFW - incoming traffic
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Update allowed services
      sudo ufw allow domain comment "DNS"
      sudo ufw allow ntp comment 'NTP'

      # >>>> Update allowed ports for App      - PHP
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9001 proto tcp comment 'PHP - Xdebug - DBGp Proxy'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9003 proto tcp comment 'PHP - Xdebug'

      # >>>> App - Symfony Local Server
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8000 proto tcp comment 'Local server - Symfony'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8081 proto tcp comment 'Local server - App 1'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8082 proto tcp comment 'Local server - App 2'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8083 proto tcp comment 'Local server - App 3'

      # >>>> Update allowed ports for Cache    - Redis
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 6379 proto tcp comment 'Redis'

      # >>>> Update allowed ports for Database - PostgreSQL
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5432 proto tcp comment 'PostgreSQL'

      # >>>> Update allowed ports for Message  - RabbitMQ
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5672  proto tcp comment 'RabbitMQ'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5552  proto tcp comment 'RabbitMQ - stream'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 15672 proto tcp comment 'RabbitMQ - http'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 25672 proto tcp comment 'RabbitMQ - clustering'

      # >>>> Update allowed ports for Server   - Nginx
      sudo ufw allow http  comment 'Nginx - HTTP'
      sudo ufw allow https comment 'Nginx - HTTPS'

      # >>>> Update allowed ports for Tools    - Remote Desktop
      #sudo ufw allow 3389/tcp comment 'Remote Desktop'
      #sudo ufw allow from 192.168.0.0/24 to 192.168.0.0/24 port 3389 proto tcp comment 'Remote Desktop'

      # >>>> Private Network - Inbound Traffic
      sudo ufw deny from 10.0.0.0/8
      sudo ufw deny from 172.16.0.0/12
      #sudo ufw deny from 192.168.0.0/16
      #sudo ufw deny from 192.168.0.0/24
      sudo ufw deny from 192.168.55.0/24

      # >>>> UFW - Outgoing traffic - Private Network - Outbound Traffic
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

      sudo ufw deny out rsync
      sudo ufw deny out ldap

      # >>>> UFW - Enable
      echo
      sudo ufw disable
      sudo ufw enable
      echo

      sudo ufw status verbose
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # ebtables - Mac Address
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> Linux - Network - ebtables - mac address"
      echo

      sudo arp -a
      echo

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

      # >>>> Devices

      #sudo ebtables -A INPUT -s xx:xx:xx:xx:xx:xx -j DROP
      #sudo ebtables -A FORWARD -s xx:xx:xx:xx:xx:xx -j DROP
      #sudo ebtables -A OUTPUT -d xx:xx:xx:xx:xx:xx -j DROP

      sudo ebtables -L
      echo
    fi
fi
