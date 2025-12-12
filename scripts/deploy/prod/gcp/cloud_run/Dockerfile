# ==============================================================================
# Stage 1: 프론트엔드 빌드 (Node.js)
# TailwindCSS와 Stimulus 자산을 빌드합니다.
# ==============================================================================
FROM node:20-alpine AS frontend_builder

WORKDIR /app

# 패키지 파일 복사 및 의존성 설치
COPY package.json package-lock.json ./
RUN npm ci

# 소스 코드 복사 및 빌드 실행 (예: npm run build)
COPY assets ./assets
COPY webpack.config.js ./
COPY tailwind.config.js ./
# Symfony Webpack Encore 또는 Asset Mapper 사용 시 설정에 맞게 조정
RUN npm run build


# ==============================================================================
# Stage 2: PHP 의존성 설치 (Composer)
# 프로덕션용 패키지만 최적화하여 설치합니다.
# ==============================================================================
FROM composer:2.6 AS composer_builder

WORKDIR /app

COPY composer.json composer.lock symfony.lock ./

# 개발용 의존성 제외(--no-dev), 클래스맵 최적화(-o)
RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --no-scripts \
    --prefer-dist \
    --no-progress


# ==============================================================================
# Stage 3: 최종 런타임 이미지 (PHP-FPM + Nginx)
# 실제 서비스가 실행될 가벼운 이미지입니다.
# ==============================================================================
FROM php:8.2-fpm-alpine

# 1) 필수 패키지 및 PHP 확장 모듈 설치 (PostgreSQL, Redis, Intl 등)
# Nginx와 Supervisord(프로세스 관리자)도 함께 설치합니다.
RUN apk add --no-cache \
    nginx \
    icu-dev \
    postgresql-dev \
    libzip-dev \
    zip \
    supervisor \
    && docker-php-ext-install \
    intl \
    pdo \
    pdo_pgsql \
    opcache \
    zip \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

# 2) PHP 설정 최적화 (OpCache 등)
# 프로덕션 환경에 맞는 php.ini 설정을 복사합니다.
COPY docker/php/conf.d/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# 3) Nginx 설정 복사
COPY docker/nginx/conf.d/default.conf /etc/nginx/http.d/default.conf

# 4) Supervisord 설정 복사 (Nginx와 PHP-FPM을 동시에 실행하기 위함)
COPY docker/supervisor/supervisord.conf /etc/supervisord.conf

WORKDIR /var/www/html

# 5) 빌드된 결과물 복사 (이전 스테이지에서 가져옴)
# Composer 의존성 복사
COPY --from=composer_builder /app/vendor ./vendor
# 프론트엔드 빌드 결과물 복사 (public/build 폴더 등)
COPY --from=frontend_builder /app/public/build ./public/build

# 6) 나머지 소스 코드 복사
COPY . .

# 7) 권한 설정 및 정리
# var 디렉토리(캐시, 로그)에 쓰기 권한 부여
RUN mkdir -p var && \
    chown -R www-data:www-data var && \
    chmod -R 777 var

# 8) 컨테이너 실행 명령 (Supervisord 실행)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# 포트 노출
EXPOSE 80
