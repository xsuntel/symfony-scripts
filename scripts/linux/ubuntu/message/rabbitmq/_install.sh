#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - RabbitMQ - Install                             https://www.rabbitmq.com/docs/install-debian
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # RabbitMQ - Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

    # >>>> RabbitMQ
    echo ">>>> RabbitMQ"
    echo

    local RABBITMQ_STATUS
    RABBITMQ_STATUS=$(systemctl is-active rabbitmq-server)
    if [ "${RABBITMQ_STATUS}" == "active" ]; then

      sudo systemctl is-active rabbitmq-server
      echo

    elif [ "${RABBITMQ_STATUS}" == "inactive" ]; then

      sudo systemctl start rabbitmq-server
      echo

    else
      (
        cd /tmp || return

        echo "- Install packages"
        # >>>> Install required packages
        local addPackageList="curl gnupg apt-transport-https"
        for pkgItem in ${addPackageList}; do
          local APT_PKG_INFO
          APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
          if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
            sudo apt install -y ${pkgItem}
            echo
          fi
        done

        ## Add GPG Key
        if [ ! -f /usr/share/keyrings/rabbitmq-archive-keyring.gpg ]; then
          curl -fsSL https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/rabbitmq-archive-keyring.gpg
        fi

        ## Add repository
        if [ ! -f /etc/apt/sources.list.d/rabbitmq.list ]; then
          echo "deb [signed-by=/usr/share/keyrings/rabbitmq-archive-keyring.gpg] http://www.rabbitmq.com/debian/ testing main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
        fi

        ## Install rabbitmq-server and its dependencies
        sudo apt-get update -y
        sudo apt-get install rabbitmq-server -y --fix-missing

        echo "- Enable this service"
        sudo systemctl enable rabbitmq-server
        echo

        echo "- Start  this service"
        sudo systemctl start rabbitmq-server
        echo

        ## Remove files
        if [ -f /etc/apt/sources.list.d/rabbitmq.list ]; then
          sudo rm -f /etc/apt/sources.list.d/rabbitmq.list
        fi

        if [ -f /etc/apt/sources.list.d/erlang.list ]; then
          sudo rm -f /etc/apt/sources.list.d/erlang.list
        fi

      )
    fi

  else
    echo "Prod Environment"
  fi
fi
