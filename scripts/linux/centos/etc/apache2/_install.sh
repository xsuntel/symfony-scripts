#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - CentOS - Apache2 - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Apache2
  sudo apt install -y apache2
  sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak

  sudo a2enmod rewrite
  sudo a2enmod ssl

  sudo systemctl reload apache2
  sudo systemctl start apache2

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # Configuration
  echo ""
  echo "    * Copy configurations regarding VirtualHost"
  echo ""
  sudo cp -rf /etc/apache2/apache2.conf /etc/apache2/apache2.bak
  sudo cp -r "${PROJECT_PATH}/scripts/vm/centos/etc/apache2/sites-available/"*.conf /etc/apache2/sites-available

  # SSL Certification
  echo ""
  echo "    * Copy SSL certifications"
  echo ""
  sudo cp -r "${PROJECT_PATH}/scripts/vm/centos/etc/ssl/certs/"*.crt /etc/ssl/certs
  sudo cp -r "${PROJECT_PATH}/scripts/vm/centos/etc/ssl/private/"*.key /etc/ssl/private
  sudo chmod 777 /etc/ssl/certs/ca-bundle.crt

  sudo a2ensite symfony.conf
  sudo a2ensite symfony_ssl.conf

  # VirtualHost
  sudo usermod -a -G www-data "${LOGNAME}"
  sudo chown -R "${LOGNAME}":www-data /var/www
  sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
  find /var/www -type f -exec sudo chmod 0664 {} \;

  echo ""
  echo "    * Enable this service"
  echo ""
  sudo systemctl enable apache2

  echo ""
  echo "    * Start this process"
  echo ""
  sudo systemctl reload apache2
  sudo systemctl restart apache2

fi
