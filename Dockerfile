FROM php:7.4-fpm-alpine3.12
# compared to
# Install gd
LABEL summary="php7.4 with extensions and external programs for randshop" \
      version="php7.4-fpm-alpine" \
      name="freinet/php7.4-randshop" \
      maintainer="Sebastian Pitsch <pitsch@freinet.de>"

USER root

RUN apk -u add --no-cache bash composer gettext libzip zlib busybox-suid
RUN apk add --no-cache gettext-dev libzip-dev zlib-dev \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) gettext \
    && apk del --no-cache gettext-dev libzip-dev zlib-dev

RUN apk add --no-cache openssh rsync mysql-client \
    && ssh-keygen -A && echo 'StrictModes no' >> /etc/ssh/sshd_config \
    && echo 'Welcome to Alpine' > /etc/motd \
    && echo '--------------------------------------------------------------------------------' >> /etc/motd \
    && php -v >> /etc/motd \
    && echo -e '--------------------------------------------------------------------------------\n' >> /etc/motd

COPY php.ini /usr/local/etc/php/conf.d/php.ini

COPY entrypoint-ssh.sh /entrypoint-ssh.sh
RUN chmod +x /entrypoint-ssh.sh

EXPOSE 9000
EXPOSE 22

