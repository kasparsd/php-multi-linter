# PHP Multitool 🔬

A docker image with multiple PHP versions and Composer v2 to install and run almost any PHP tool.

Similar tools:

- [`phpqa` Docker image](https://github.com/jakzal/phpqa) which includes dozens of PHP tools.

## How it Works

- The [Docker image](Dockerfile) installs multiple PHP versions and Composer v2.

- The `composer.json` and `composer.lock` files are copied to the `/app` directory inside the container which is also configured as the `COMPOSER_HOME` directory.

- All Composer packages from [`composer.json`](composer.json) are installed globally.

- The `/app/vendor/bin` directory is added to the `PATH` inside the container so that all Composer package binaries can be run directly.

- The entrypoint for all commands is set to [`entrypoint.sh`](entrypoint.sh) which reads the `PHPBIN` environment variable value passed to the container and sets the `php` binary alias to `/usr/bin/${PHPBIN}`.

## Usage

Navigate to your PHP project directory and run:

    docker run --rm -v .:/code -e PHPBIN=php8.4 ghcr.io/kasparsd/php-multitool:latest php -v

where `-e PHPBIN=php8.4` sets the default PHP CLI binary to `php8.4` (during [entrypoint.sh](entrypoint.sh)), `-v .:/code` mounts the current working directory into `/code`, and runs `php -v` to print out the PHP version.

The following `PHPBIN` values are supported: `php5.6`, `php7.2` `php7.4`, `php8.0`, `php8.1`, `php8.2`, `php8.3`, `php8.4` (see [Dockerfile](Dockerfile)).

The default command is set to `composer global show -vvv` which lists all of the globally installed Composer packages:

    docker run --rm ghcr.io/kasparsd/php-multitool:latest

    Changed current directory to /app
    Running 2.2.24 (2024-06-10 22:51:52) with PHP 7.4.33 on Linux / 6.10.4-linuxkit
    Reading ./composer.json (/app/composer.json)
    Loading config file ./composer.json (/app/composer.json)
    Checked CA file /etc/pki/tls/certs/ca-bundle.crt does not exist or it is not a file.
    Checked directory /etc/pki/tls/certs/ca-bundle.crt does not exist or it is not a directory.
    Checked CA file /etc/ssl/certs/ca-certificates.crt: valid
    Reading /app/vendor/composer/installed.json
    Loading plugin PHPCSStandards\Composer\Plugin\Installers\PHPCodeSniffer\Plugin (from dealerdi...
    dealerdirect/phpcodesniffer-composer-installer   v1.0.0              PHP_CodeSniffer Standard...
    php-parallel-lint/php-parallel-lint              v1.4.0              This tool checks the syn...
    phpcompatibility/php-compatibility               dev-develop d9ae4b0 A set of sniffs for PHP_...
    phpcompatibility/phpcompatibility-all            1.1.3               A set of rulesets for PH...
    phpcompatibility/phpcompatibility-joomla         2.1.3               A ruleset for PHP_CodeSn...
    phpcompatibility/phpcompatibility-paragonie      1.3.3               A set of rulesets for PH...
    phpcompatibility/phpcompatibility-passwordcompat 1.0.4               A ruleset for PHP_CodeSn...
    phpcompatibility/phpcompatibility-symfony        1.2.1               A set of rulesets for PH...
    phpcompatibility/phpcompatibility-wp             2.1.5               A ruleset for PHP_CodeSn...
    phpcsstandards/phpcsutils                        1.0.12              A suite of utility funct...
    squizlabs/php_codesniffer                        3.10.2              PHP_CodeSniffer tokenize...


### Runing Locally

1. Build the image locally using `docker compose build`.

2. Run `parallel-lint` against the files in the [`tests` directory](tests) which is the default behaviour:

       docker compose run --rm -e PHPBIN=php8.2 php-multitool parallel-lint ./tests

## Credits

Created by [Kaspars Dambis](https://kaspars.net).