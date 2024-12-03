FROM debian:11

ENV DRUPAL_DB_HOST=db \
    DRUPAL_DB_USER=drupal \
    DRUPAL_DB_PASSWORD=drupal_password \
    DRUPAL_DB_NAME=drupal6

# Install prerequisites
RUN apt-get update && apt-get install -y \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    wget \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Add Sury PHP repository
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Install Apache and PHP 5.6
RUN apt-get update && apt-get install -y \
    apache2 \
    php5.6 \
    libapache2-mod-php5.6 \
    php5.6-mysql \
    php5.6-gd \
    php5.6-curl \
    php5.6-xml \
    php5.6-mbstring \
    php5.6-cli \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Configure Apache
RUN a2enmod rewrite
RUN a2enmod php5.6

# Set working directory
WORKDIR /var/www/html

# Download and extract Drupal 6
RUN wget https://ftp.drupal.org/files/projects/drupal-6.38.tar.gz \
    && tar xzf drupal-6.38.tar.gz \
    && mv drupal-6.38/* . \
    && rm -rf drupal-6.38 drupal-6.38.tar.gz index.html

# Configure PHP settings
RUN echo 'mbstring.http_input = pass' >> /etc/php/5.6/apache2/php.ini \
    && echo 'mbstring.http_output = pass' >> /etc/php/5.6/apache2/php.ini

# Copy default settings and set permissions
RUN cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php \
    && sed -i "s|mysql://username:password@localhost/databasename|mysql://${DRUPAL_DB_USER}:${DRUPAL_DB_PASSWORD}@${DRUPAL_DB_HOST}/${DRUPAL_DB_NAME}|g" /var/www/html/sites/default/settings.php \
    && chmod 777 /var/www/html/sites/default/settings.php \
    && mkdir -p /var/www/html/sites/default/files \
    && chmod 777 /var/www/html/sites/default/files

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copy custom php.ini
COPY php.ini /etc/php/5.6/apache2/php.ini

# Copy virtual host configuration
COPY drupal.conf /etc/apache2/sites-available/000-default.conf

# Create Apache startup script
RUN echo '#!/bin/bash\n\
source /etc/apache2/envvars\n\
apache2 -D FOREGROUND' > /usr/local/bin/apache2-start \
    && chmod +x /usr/local/bin/apache2-start

EXPOSE 80

CMD ["/usr/local/bin/apache2-start"]
