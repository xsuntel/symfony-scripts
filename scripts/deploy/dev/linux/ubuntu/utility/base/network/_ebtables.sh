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
      # ebtables - Mac Address
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> Linux - Network - ebtables - mac address"
      echo

      sudo ebtables -F

      # >>>> Network - Firewall - IPv6

      sudo ebtables -A FORWARD -p IPv6 -j DROP
      sudo ebtables -A INPUT -p IPv6 -j DROP
      sudo ebtables -A OUTPUT -p IPv6 -j DROP

      # >>>> Network - Firewall - IPv4

      sudo ebtables -A INPUT -d Multicast --log-level info --log-prefix "EBFW_MCAST_DROP: " -j DROP
      sudo ebtables -A INPUT -p IPv4 --ip-dst 224.0.0.251 -j ACCEPT

      sudo ebtables -A OUTPUT -p IPv4 --ip-proto udp --ip-sport 67 -j DROP

      # >>>> Network - Firewall - Devices - Mobile

      #sudo ebtables -A INPUT -s xx:xx:xx:xx:xx:xx -j DROP
      #sudo ebtables -A FORWARD -s xx:xx:xx:xx:xx:xx -j DROP
      #sudo ebtables -A OUTPUT -d xx:xx:xx:xx:xx:xx -j DROP

      # >>>> Network - Firewall - Devices - Laptop

      #sudo ebtables -A INPUT -s xx:xx:xx:xx:xx:xx -j DROP
      #sudo ebtables -A FORWARD -s xx:xx:xx:xx:xx:xx -j DROP
      #sudo ebtables -A OUTPUT -d xx:xx:xx:xx:xx:xx -j DROP

      sudo ebtables -L
      echo
    fi
fi
