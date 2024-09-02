FROM debian:bookworm-slim

LABEL org.opencontainers.image.source https://github.com/kasparsd/php-multi-linter

# System dependencies.
RUN apt-get update \
    && apt-get install --yes --no-install-recommends git curl wget gnupg2 ca-certificates lsb-release apt-transport-https

# Add https://packages.sury.org/php/ repository and install PHP.
RUN curl --location https://packages.sury.org/php/apt.gpg | apt-key add - \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update

# Install PHP versions.
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        php5.6-cli \
        php7.2-cli \
        php7.4-cli \
        php8.1-cli \
        php8.2-cli \
        php8.3-cli \
        php8.4-cli \
    && apt-get clean

# Set the default php binary version.
RUN update-alternatives --set php /usr/bin/php7.4

WORKDIR /app

COPY lint.php ./

# Install PHP-Parallel-Lint.
RUN curl --location https://github.com/php-parallel-lint/PHP-Parallel-Lint/releases/download/v1.4.0/parallel-lint.phar -o /usr/bin/parallel-lint \
    && chmod +x /usr/bin/parallel-lint

CMD ["parallel-lint"]