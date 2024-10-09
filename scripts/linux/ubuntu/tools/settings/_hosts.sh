#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Hosts
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # Hardware
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Check status
  echo ">>>> CPU"
  top -b -n 1 | head -n 5
  echo

  echo ">>>> Memory"
  sudo sysctl -w vm.min_free_kbytes=2000000                                                           # default :16384
  sudo sysctl -w vm.vfs_cache_pressure=10000                                                          # default : 100
  sudo sysctl -w vm.drop_caches=2
  sudo sysctl -w vm.swappiness=0
  echo

  echo 2 > sudo /proc/sys/vm/drop_caches
  echo 0 > sudo /proc/sys/vm/swappiness
  sudo swapoff -a && sudo swapon -a
  free -m
  echo

  sudo slabtop -o | grep dentry
  echo

  cat /proc/meminfo | grep -i anon
  echo

  echo ">>>> SSD"
  df -h
  echo

  echo ">>>> Network"
  # >>>> Network - ipv6
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
  sudo cat /proc/sys/net/ipv6/conf/all/disable_ipv6
  echo

  netstat -napo | grep -i time_wait
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Host
  # --------------------------------------------------------------------------------------------------------------------

  echo ">>>> Linux - Hosts"
  echo

  local PROJECT_HOST_NAME
  PROJECT_HOST_NAME=$(grep -i "symfony.local" /etc/hosts | awk '{print $2}' | head -n 1)
  if [ ! "${PROJECT_HOST_NAME}" ]; then
    echo $'\n127.0.0.1 symfony.local' | sudo tee -a /etc/hosts
    echo $'\n127.0.0.1 api.symfony.local' | sudo tee -a /etc/hosts
    echo $'\n127.0.0.1 cdn.symfony.local' | sudo tee -a /etc/hosts
    echo $'\n127.0.0.1 www.symfony.local' | sudo tee -a /etc/hosts

    echo ">>>> Hosts"
    sudo grep -v '#' /etc/hosts
    echo
  fi

fi