FROM debian:bookworm-slim

LABEL org.opencontainers.image.source=https://github.com/kasparsd/php-multitool

# System dependencies.
RUN apt-get update \
    && apt-get install --yes --no-install-recommends git zip unzip curl wget gnupg2 ca-certificates lsb-release apt-transport-https

# Add https://packages.sury.org/php/ repository and install PHP.
RUN curl --location https://packages.sury.org/php/apt.gpg | apt-key add - \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update

# Install PHP versions.
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        php5.6-cli php5.6-zip php5.6-xmlwriter \
        php7.2-cli php7.2-zip php7.2-xmlwriter \
        php7.4-cli php7.4-zip php7.4-xmlwriter \
        php8.0-cli php8.0-zip php8.0-xmlwriter \
        php8.1-cli php8.1-zip php8.1-xmlwriter \
        php8.2-cli php8.2-zip php8.2-xmlwriter \
        php8.3-cli php8.3-zip php8.3-xmlwriter \
        php8.4-cli php8.4-zip php8.4-xmlwriter \
    && apt-get clean

# Set the default php binary version.
RUN update-alternatives --set php /usr/bin/php7.4

# Install Composer.
RUN curl --silent --show-error https://getcomposer.org/installer \
        | php -- --install-dir=/usr/bin --filename=composer --2.2

# Persist the packages and cache between runs.
VOLUME /root/.composer

COPY composer.json composer.lock entrypoint.sh /root/.composer/

# Add Composer global bin directory to PATH.
ENV PATH=/root/.composer/vendor/bin:${PATH}

# Install all tools.
RUN composer global install --no-cache --no-interaction

# Run commands inside this directory by default.
WORKDIR /code

ENTRYPOINT [ "/root/.composer/entrypoint.sh" ]

CMD ["composer", "global", "show", "-vvv"]