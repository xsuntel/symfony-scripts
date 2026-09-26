#!/bin/bash

#set -euo pipefail
# ----------------------------------------------------------------------------------------------------------------------
# Scripts - Deploy - Dev - Linux - Ubuntu - Nginx - Install
# ----------------------------------------------------------------------------------------------------------------------
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "prod" ]; then

    # ------------------------------------------------------------------------------------------------------------------
    # Nginx - Preconditions
    # ------------------------------------------------------------------------------------------------------------------
    # PHP_VERSION comes from `.env.app` and is sourced by `_project.sh` (prod deploy.sh runs
    # setProject → setNginx). The fastcgi_pass socket path in symfony.conf depends on this value, so if it
    # is empty nginx ends up pointing at a wrong path such as `/run/php/php-fpm.sock` and serves silent
    # 502s.
    if [ -z "${PHP_VERSION:-}" ]; then
      echo "[ ERROR ] PHP_VERSION is empty — check .env.app"
      echo "          deploy.sh must call setNginx only after setProject (which sources .env.app)."
      setExit
    fi

    # >>>> Apache2
    if [ -f /etc/apache2/apache2.conf ]; then
      sudo systemctl stop apache2
      sudo systemctl disable apache2
      sudo apt purge -y apache2
      sudo fuser -k 80/tcp
    fi

    if [ -d /var/www/html ]; then
      sudo rm -rf /var/www/html
    fi

    # ------------------------------------------------------------------------------------------------------------------
    # Nginx - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Nginx
    echo ">>>> Nginx"
    echo

    NGINX_STATUS=$(dpkg -l | grep -i "nginx" | awk '{print $2}' | cut -d ':' -f1 | awk "/^nginx$/")
    if [ "${NGINX_STATUS}" != "nginx" ]; then
      sudo apt install -y nginx
      echo

      sudo systemctl enable nginx
      echo
    fi

    # ------------------------------------------------------------------------------------------------------------------
    # Nginx - Update the configuration
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Nginx - Configuration"
    echo

    # >>>> Nginx - Configuration
    sudo rm -f /etc/nginx/*.default

    if [ -f /etc/nginx/nginx.conf ]; then
      sudo cp -fv "${PROJECT_PATH}"/scripts/base/server/nginx/nginx.conf /etc/nginx/nginx.conf
    fi

    # >>>> Nginx - Project
    PROJECT_NAME=$(basename "$(realpath "${PROJECT_PATH}")")
    if [ -f /etc/nginx/conf.d/symfony.conf ]; then
      sudo rm -f /etc/nginx/conf.d/symfony.conf
    fi
    sudo cp -fv "${PROJECT_PATH}"/scripts/base/server/nginx/conf.d/symfony.conf /etc/nginx/conf.d/symfony.conf

    # >>>> Nginx - Pin the PHP version in the PHP-FPM socket path.
    #
    # The `fastcgi_pass` socket path embeds the PHP version (/run/php/phpX.Y-fpm.sock). The repository
    # source keeps it as `__PHP_VERSION__` and substitutes it here — it must resolve to the **same value**
    # as `listen` in the FPM-side `pool.d/www.conf`, which uses the same placeholder
    # (scripts/base/app/php/_install.sh).
    #
    # This file used to hardcode 8.4. On a PHP upgrade FPM binds phpX.Y-fpm.sock while nginx keeps looking
    # for a php8.4-fpm.sock that does not exist, so every PHP request falls to a 502 — and because nginx
    # does not treat a missing socket as a configuration error, `nginx -t` still passes (the breakage only
    # shows at runtime).
    #
    # The regex does not pin the version literal — any other X.Y left behind by a previous deployment is
    # realigned to the current version as well.
    sudo sed -i -E "s#__PHP_VERSION__#${PHP_VERSION}#g; s#unix:/run/php/php[0-9]+\.[0-9]+-fpm\.sock#unix:/run/php/php${PHP_VERSION}-fpm.sock#g" \
      /etc/nginx/conf.d/symfony.conf

    echo "  >> fastcgi_pass : $(grep -m1 'fastcgi_pass' /etc/nginx/conf.d/symfony.conf | tr -s ' ')"
    echo

    if [ -d /etc/nginx/sites-available ]; then
      sudo rm -fv /etc/nginx/sites-available/*
    fi

    if [ -d /etc/nginx/sites-enabled ]; then
      sudo rm -fv /etc/nginx/sites-enabled/*
    fi

    # >>>> Nginx - Create log files
    if [ ! -f /var/log/nginx/www_access.log ]; then
      sudo cat /dev/null > /var/log/nginx/www_access.log
    else
      if [ -f /var/log/nginx/www_access.log.1 ]; then
        sudo rm -fv /var/log/nginx/www_access.log.*
        echo
      fi

      sudo chmod 777 /var/log/nginx/www_access.log
    fi

    if [ ! -f /var/log/nginx/www_error.log ]; then
      sudo cat /dev/null > /var/log/nginx/www_error.log
    else
      if [ -f /var/log/nginx/www_error.log.1 ]; then
        sudo rm -fv /var/log/nginx/www_error.log.*
        echo
      fi

      sudo chmod 777 /var/log/nginx/www_error.log
    fi
    echo

    # >>>> Nginx - Update permissions
    sudo chown -R root:root /etc/nginx
    sudo chown -R root:root /var/log/nginx
    sudo chmod -R 755 /var/log/nginx
    echo

    # >>>> Nginx - Symfony - Setting up or Fixing File Permissions - https://symfony.com/doc/current/setup/file_permissions.html
    # Verbatim from the Symfony file-permissions docs; pgrep cannot reproduce the
    # "first non-root web server user" selection this relies on.
    # shellcheck disable=SC2009
    HTTPDUSER="$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)"
    sudo usermod -a -G "${HTTPDUSER}" "$(whoami)"

    # --------------------------------------------------------------------------------------------------------------------
    # Nginx - Check status
    # --------------------------------------------------------------------------------------------------------------------
    echo ">>>> Nginx - Status"
    echo

    # >>>> Nginx - Configuration validation comes **before** start/reload.
    # Previously `nginx -t` was only printed after start, so a deployment with a broken configuration
    # printed the cause only once startup had already failed. The rule (SoT) also requires "always run
    # nginx -t before a reload".
    # @see .claude/rules/server-nginx-rule.md — `## General Rules`
    if ! sudo nginx -t; then
      echo
      echo "[ ERROR ] Nginx configuration validation failed — resolve the errors above first."
      echo "          Running start/reload in this state makes nginx stop serving all requests."
      setExit
    fi
    echo

    NGINX_STATUS=$(systemctl is-active nginx)
    if [ "${NGINX_STATUS}" != "active" ]; then
      sudo systemctl start nginx
      echo
    else
      # Already running: apply the configuration just deployed without downtime — a reload, not a restart.
      sudo systemctl reload nginx
      echo
    fi

    sudo nginx -v
    echo

  fi

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Mac - MacOS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    # >>>> Nginx
    echo ">>>> Nginx"
    echo
  fi
  echo

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows - WSL2
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    # >>>> Nginx
    echo ">>>> Nginx"
    echo
  fi
  echo

else
  echo "Please check Operating System"
  setExit
fi
