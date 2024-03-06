FROM php:8.3-apache AS builder

RUN apt-get update && apt-get install -y \
        default-mysql-client \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libonig-dev \
        libxml2-dev \
        libicu-dev \
        zlib1g-dev \
        libmcrypt-dev \
        curl \
        unzip \
        git \
    && docker-php-ext-install -j$(nproc) \
        iconv \
        gd \
        mbstring \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        intl \
        xml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
&& apt-get autoremove -y \
&& curl -sS https://get.symfony.com/cli/installer | bash \
&& cp /root/.symfony5/bin/symfony /usr/local/bin/symfony

WORKDIR /app
COPY . /app

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN COMPOSER_ALLOW_SUPERUSER=1 composer install


FROM php:8.3.3-apache
RUN apt-get update && apt-get install -y \
        default-mysql-client \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libonig-dev \
        libxml2-dev \
        libicu-dev \
        zlib1g-dev \
        libmcrypt-dev \
        curl \
        unzip \
        git \
    && docker-php-ext-install -j$(nproc) \
        iconv \
        gd \
        mbstring \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        intl \
        xml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
&& apt-get autoremove -y

COPY --from=builder /root/.symfony5/bin/symfony /usr/local/bin/symfony
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# RUN a2enmod rewrite
RUN /usr/sbin/a2enmod rewrite && /usr/sbin/a2enmod headers && /usr/sbin/a2enmod expires
COPY apache.conf /etc/apache2/sites-enabled/000-default.conf

# Set the working directory
WORKDIR /var/www/html

# Copy the built Symfony application from the previous stage
COPY --from=builder /app .

# Ensure that cache, log and session directories are writable
RUN mkdir -p /var/www/html/var && chown -R www-data:www-data /var/www/html/var