# ======================================================================================================================
# Dockerfile - PHP-FPM & Nginx & Supervisor                                                 https://hub.docker.com/_/php
# ======================================================================================================================
ARG PHP_VERSION="8.4"

# ----------------------------------------------------------------------------------------------------------------------
# STEP - 01 : Pull official base image
# ----------------------------------------------------------------------------------------------------------------------
FROM php:${PHP_VERSION}-fpm-alpine
LABEL "purpose"="webapp"

# ----------------------------------------------------------------------------------------------------------------------
# STEP - 02 : Set environment variables
# ----------------------------------------------------------------------------------------------------------------------
RUN echo "[ PHP ] Set environment variables"

ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"

# ----------------------------------------------------------------------------------------------------------------------
# STEP - 03 : Set Work directory
# ----------------------------------------------------------------------------------------------------------------------
RUN echo "[ PHP ] Set Work directory "

WORKDIR /var/www/app

# ----------------------------------------------------------------------------------------------------------------------
# STEP - 04 : Install packages
# ----------------------------------------------------------------------------------------------------------------------
RUN echo "[ PHP ] Install packages"

RUN set -eux; \
    # [Runtime-deps]
    apk add --no-cache \
        nginx \
        supervisor \
        libpq \
        libzip \
        libxml2 \
        libpng \
        libjpeg-turbo \
        freetype \
        icu \
        icu-libs \
        curl \
        rabbitmq-c; \
    \
    # [Build-deps]
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        linux-headers \
        libzip-dev \
        libpq-dev \
        libxml2-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        icu-dev \
        curl-dev \
        rabbitmq-c-dev; \
    \
    # PHP Extention
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j$(nproc) \
        gd \
        sockets \
        intl \
        zip \
        pdo \
        pdo_pgsql \
        bcmath; \
    \
    # PECL (Redis, AMQP)
    pecl install redis amqp; \
    docker-php-ext-enable redis amqp opcache; \
    \
    # Delete some files
    apk del .build-deps; \
    rm -rf /tmp/pear /var/cache/apk/*; \
    docker-php-source delete;

# ----------------------------------------------------------------------------------------------------------------------
# STEP - 05 : Update configuration
# ----------------------------------------------------------------------------------------------------------------------
RUN echo "[ PHP ] Update a configuration"

# >>>> PHP-FPM
RUN rm -f $PHP_INI_DIR/conf.d/php.ini
COPY scripts/containers/prod/php/etc/php.ini $PHP_INI_DIR/conf.d/php.ini

COPY scripts/containers/prod/php/etc/conf.d/docker-php-ext-opcache.ini $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini

# >>>> Nginx
RUN rm -f /etc/nginx/nginx.conf
COPY scripts/containers/prod/nginx/etc/nginx/nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/nginx/conf.d/default.conf
COPY scripts/containers/prod/nginx/etc/nginx/conf.d/www.conf /etc/nginx/conf.d/www.conf

# >>>> Supervisor
RUN mkdir -p /etc/supervisor.d
COPY scripts/containers/prod/supervisor/etc/supervisord.conf /etc/supervisord.conf
COPY scripts/containers/prod/supervisor/etc/supervisor.d/messenger-worker.ini /etc/supervisor.d/messenger-worker.ini

# >>>> Shell-script - Entrypoint
COPY scripts/containers/prod/entrypoint.sh /usr/local/bin/entrypoint

# ----------------------------------------------------------------------------------------------------------------------
# STEP - 06 : Copy source files
# ----------------------------------------------------------------------------------------------------------------------
RUN echo "[ PHP ] Copy source files"

COPY ./app .

RUN set -eux; \
    # >>>> PHP-FPM
    chown -R www-data:www-data /var/www/app; \
    chmod -R 775 /var/www/app/var; \
    # >>>> Nginx
    mkdir -p /var/log/nginx; \
    chmod -R 775 /var/log/nginx; \
    chmod +x /usr/local/bin/entrypoint; \
    # >>>> Supervisor
    mkdir -p /var/log/supervisor; \
    chown -R www-data:www-data /var/log/supervisor /etc/supervisor.d;

# ----------------------------------------------------------------------------------------------------------------------
# STEP - 07 : Start the service
# ----------------------------------------------------------------------------------------------------------------------
EXPOSE 8080
USER www-data

# >>>> Shell-script
ENTRYPOINT ["entrypoint"]
