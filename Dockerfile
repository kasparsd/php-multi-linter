FROM debian:bookworm-slim

# System dependencies.
RUN apt-get update \
    && apt-get install --yes --no-install-recommends curl wget gnupg2 ca-certificates lsb-release apt-transport-https

# Add https://packages.sury.org/php/ repository and install PHP.
RUN curl --location https://packages.sury.org/php/apt.gpg | apt-key add - \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes php5.6-cli php7.2-cli php7.4-cli php8.1-cli php8.2-cli php8.3-cli php8.4-cli \
    && apt-get clean

WORKDIR /app

COPY lint.php lint.php

CMD ["php7.4", "lint.php"]