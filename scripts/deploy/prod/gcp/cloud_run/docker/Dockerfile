# ======================================================================================================================
# Dockerfile - PHP                                                                          https://hub.docker.com/_/php
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
        libpq \
        libzip \
        libxml2 \
        libpng \
        libjpeg-turbo \
        freetype \
        icu \
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

RUN set -eux; \
    sed -i 's/^listen = 9000$/listen = 8080/g' /usr/local/etc/php-fpm.d/www.conf; \
    rm -f $PHP_INI_DIR/php.ini-*;

COPY --link scripts/deploy/prod/gcp/cloud_run/docker/php/etc/php.ini $PHP_INI_DIR/php.ini
COPY --link scripts/deploy/prod/gcp/cloud_run/docker/php/etc/conf.d/docker-php-ext-opcache.ini $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini

# ----------------------------------------------------------------------------------------------------------------------
# STEP - 06 : Copy source files
# ----------------------------------------------------------------------------------------------------------------------
RUN echo "[ PHP ] Copy source files"

COPY --link ./app ./

RUN set -eux; \
    chown -R www-data:www-data var; \
    chmod -R 775 var;

# ----------------------------------------------------------------------------------------------------------------------
# STEP - 07 : Start the service
# ----------------------------------------------------------------------------------------------------------------------
EXPOSE 8080
USER www-data

CMD ["php-fpm", "-F"]
