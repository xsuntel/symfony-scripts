#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Firewall
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # Firewall
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> Firewall"
  echo

    # >>>> Firewall
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
      sudo ufw disable
    fi

    # >>>> Reset current rules
    sudo ufw --force reset
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - default
    # ------------------------------------------------------------------------------------------------------------------
    sudo ufw default allow outgoing
    sudo ufw default deny incoming
    sudo ufw logging on
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - allow
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Update allowed services
    sudo ufw allow ntp comment 'NTP'

    # >>>> Update allowed ports for Cache    - Redis
    sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 6379 proto tcp comment 'Redis'

    # >>>> Update allowed ports for Database - PostgreSQL
    sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5432 proto tcp comment 'PostgreSQL'

    # >>>> Update allowed ports for Message  - RabbitMQ
    sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5672 proto tcp comment 'RabbitMQ'
    sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 15672 proto tcp comment 'RabbitMQ - UI'

    # >>>> Update allowed ports for Server   - Nginx
    sudo ufw allow 80/tcp  comment 'Nginx - HTTP'
    sudo ufw allow 443/tcp comment 'Nginx - HTTPS'

    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # >>>> Update allowed ports for App      - PHP
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9001 proto tcp comment 'PHP - Xdebug - DBGp Proxy'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9003 proto tcp comment 'PHP - Xdebug'

      # >>>> Update allowed ports for Server   - Local
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8000 proto tcp comment 'Local server - 0'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8010 proto tcp comment 'Local server - 1'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8020 proto tcp comment 'Local server - 2'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8030 proto tcp comment 'Local server - 3'

      # >>>> Update allowed ports for Tools    - Remote Desktop
      #sudo ufw allow from 192.168.0.0/24 to 192.168.0.0/24 port 3389 proto tcp comment 'Remote Desktop'
    fi

    # >>>> Update allowed ports for Tools    - Remote Desktop
    #sudo ufw allow 3389/tcp comment 'Remote Desktop'

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - deny
    # ------------------------------------------------------------------------------------------------------------------
    sudo ufw deny from any to any port 21 comment 'FTP'
    sudo ufw deny from any to any port 22 comment 'SSH'
    sudo ufw deny from any to any port 25 comment 'SMTP'

    sudo ufw deny from any to any port 139 comment 'SMB'
    sudo ufw deny from any to any port 445 comment 'SMB'

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - Enable
    # ------------------------------------------------------------------------------------------------------------------
    echo
    sudo ufw disable
    sudo ufw enable
    echo

    sudo ufw status verbose
    echo

else
  echo "Please check Operating System"
  setExit
fi