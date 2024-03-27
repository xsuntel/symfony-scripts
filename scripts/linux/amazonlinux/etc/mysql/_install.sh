#!/bin/bash
# ======================================================================================================================
# Scripts - VM - Amazon Linux - MySQL - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> MySQL
  if [ ! -f /var/lib/mysql/mysql.sock ]; then
    sudo dnf install -y mysql mysql-server --skip-broken

    sudo systemctl enable mysqld

    sudo systemctl start mysqld
  else
    echo "There is a file : /var/lib/mysql/mysql.sock"
  fi

  echo ""
  echo "    * Update a temporary password"
  echo ""
  if [ -f /var/log/mysqld.log ]; then
    TEMP_PASSWORD=$(sudo grep "A temporary password" /var/log/mysqld.log | cut -d "@" -f2 | cut -d " " -f2)
    echo "    - a temp password: ${TEMP_PASSWORD}"
    echo ""
    #if [ ${TEMP_PASSWORD} != ${DATABASE_PASSWORD} ]; then
    #  mysqladmin -u root -p ${TEMP_PASSWORD} password ${DATABASE_PASSWORD}
    #  mysql -u root -p ${DATABASE_PASSWORD} -e "drop user if exists root@'%';create user root@'%' IDENTIFIED BY '${DATABASE_PASSWORD}';"
    #  mysql -u root -p ${DATABASE_PASSWORD} -e "grant replication slave on *.* to root@'%' with  grant option;flush privileges;"
    #else
    #  echo "You should check a password for MySQL"
    #fi
  else
    echo "There is no the file : /var/log/mysqld.log"
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------

fi
