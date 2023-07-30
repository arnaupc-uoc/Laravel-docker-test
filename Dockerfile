# Dockerfile for Laravel with PHP 8 and MySQL

# Set the base image
FROM php:8.2-fpm

# Maintainer
LABEL maintainer="arnaupc"

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel
RUN composer install

# Generate application key
RUN php artisan key:generate

# Configure nginx
COPY ./nginx.conf /etc/nginx/sites-available/default

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
