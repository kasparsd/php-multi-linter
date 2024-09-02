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

The default `php` is mapped to `php7.4` (when no `PHPBIN` is set) and the following `PHPBIN` values are supported: `php5.6`, `php7.2` `php7.4`, `php8.0`, `php8.1`, `php8.2`, `php8.3`, `php8.4` (see [Dockerfile](Dockerfile)).

The default command is set to `composer global show -vvv` which lists all of the globally installed Composer packages:

    docker run --rm ghcr.io/kasparsd/php-multitool:latest

    Changed current directory to /root/.composer
    Running 2.2.24 (2024-06-10 22:51:52) with PHP 7.4.33 on Linux / 6.10.4-linuxkit
    Reading ./composer.json (/root/.composer/composer.json)
    Loading config file ./composer.json (/root/.composer/composer.json)
    Checked CA file /etc/pki/tls/certs/ca-bundle.crt does not exist or it is not a file.
    Checked directory /etc/pki/tls/certs/ca-bundle.crt does not exist or it is not a directory.
    Checked CA file /etc/ssl/certs/ca-certificates.crt: valid
    Executing command (/root/.composer): git branch -a --no-color --no-abbrev -v
    Executing command (/root/.composer): git describe --exact-match --tags
    Executing command (CWD): git --version
    Executing command (/root/.composer): git log --pretty="%H" -n1 HEAD --no-show-signature
    Executing command (/root/.composer): hg branch
    Executing command (/root/.composer): fossil branch list
    Executing command (/root/.composer): fossil tag list
    Executing command (/root/.composer): svn info --xml
    Reading /root/.composer/vendor/composer/installed.json
    Loading plugin PHPCSStandards\Composer\Plugin\Installers\PHPCodeSniffer\Plugin (from dealerdirect/phpcodesniffer-composer-installer)
    dealerdirect/phpcodesniffer-composer-installer   v1.0.0              PHP_CodeSniffer Standards Composer Installer Plugin
    php-parallel-lint/php-parallel-lint              v1.4.0              This tool checks the syntax of PHP files about 20x faster than serial check.
    phpcompatibility/php-compatibility               dev-develop d9ae4b0 A set of sniffs for PHP_CodeSniffer that checks for PHP cross-version compatibility.
    phpcompatibility/phpcompatibility-all            1.1.3               A set of rulesets for PHP_CodeSniffer to check for PHP cross-version compatibility issues and opportunities to modernize code in PHP projects.
    phpcompatibility/phpcompatibility-joomla         2.1.3               A ruleset for PHP_CodeSniffer to check for PHP cross-version compatibility issues in projects, while accounting for polyfills provided by Joomla.
    phpcompatibility/phpcompatibility-paragonie      1.3.3               A set of rulesets for PHP_CodeSniffer to check for PHP cross-version compatibility issues in projects, while accounting for polyfills provided by the Paragonie polyfill libraries.
    phpcompatibility/phpcompatibility-passwordcompat 1.0.4               A ruleset for PHP_CodeSniffer to check for PHP cross-version compatibility issues in projects, while accounting for polyfills provided by ircmaxell's password_compat library.
    phpcompatibility/phpcompatibility-symfony        1.2.1               A set of rulesets for PHP_CodeSniffer to check for PHP cross-version compatibility issues in projects, while accounting for polyfills provided by the Symfony polyfill libraries.
    phpcompatibility/phpcompatibility-wp             2.1.5               A ruleset for PHP_CodeSniffer to check for PHP cross-version compatibility issues in projects, while accounting for polyfills provided by WordPress.
    phpcsstandards/phpcsextra                        1.2.1               A collection of sniffs and standards for use with PHP_CodeSniffer.
    phpcsstandards/phpcsutils                        1.0.12              A suite of utility functions for use with PHP_CodeSniffer
    squizlabs/php_codesniffer                        3.10.2              PHP_CodeSniffer tokenizes PHP, JavaScript and CSS files and detects violations of a defined set of coding standards.
    wp-coding-standards/wpcs                         3.1.0               PHP_CodeSniffer rules (sniffs) to enforce WordPress coding conventions

### Runing Locally

Note: The project root directory is mapped to `/code` inside the container in `docker-compose.yml`.

1. Build the image locally using `docker compose build`.

2. Run `parallel-lint` against the files in the [`tests` directory](tests) which is the default behaviour:

       docker compose run --rm php-multitool parallel-lint ./tests

### Create `php-multitool` Alias

Add an alias to your shell profile (e.g., `~/.bashrc` or `~/.zshrc`) for each version of PHP as needed:

    alias php-multitool-8.4='docker run --rm -e PHPBIN=php8.4 -v .:/code ghcr.io/kasparsd/php-multitool:latest'

and then use it like this:

    php-multitool-8.4 composer global show

## Available Tools

All examples below assume that you're running the commands from the root of your PHP project directory.

### phpcs and phpcbf (PHP_CodeSniffer)

The following PHP_CodeSniffer standards are installed by default:

    docker run --rm ghcr.io/kasparsd/php-multitool:latest phpcs -i
    
    The installed coding standards are MySource, PEAR, PSR1, PSR2, PSR12, Squiz, Zend, PHPCompatibility, PHPCompatibilityJoomla, PHPCompatibilityParagonieRandomCompat, PHPCompatibilityParagonieSodiumCompat, PHPCompatibilityPasswordCompat, PHPCompatibilitySymfonyPolyfillPHP54, PHPCompatibilitySymfonyPolyfillPHP55, PHPCompatibilitySymfonyPolyfillPHP56, PHPCompatibilitySymfonyPolyfillPHP70, PHPCompatibilitySymfonyPolyfillPHP71, PHPCompatibilitySymfonyPolyfillPHP72, PHPCompatibilitySymfonyPolyfillPHP73, PHPCompatibilitySymfonyPolyfillPHP74, PHPCompatibilitySymfonyPolyfillPHP80, PHPCompatibilityWP, Modernize, NormalizedArrays, Universal, PHPCSUtils, WordPress, WordPress-Core, WordPress-Docs and WordPress-Extra

#### Example: Check WordPress PHP Coding Standards

    docker run --rm -v .:/code ghcr.io/kasparsd/php-multitool:latest \
        phpcs -p --standard=WordPress --extensions=php .

where `--standard=WordPress` can be any of the installed PHP_CodeSniffer standards.

#### Example: Check PHP 8 Compatibility for WordPress Projects

    docker run --rm -v .:/code -e PHPBIN=php7.4 ghcr.io/kasparsd/php-multitool:latest \
        phpcs -p --standard=PHPCompatibilityWP --runtime-set testVersion 5.6- --extensions=php .

where `--runtime-set testVersion 5.6-` sets the target PHP version to PHP 5.6 and newer.

### parallel-lint

Check PHP files for syntax errors:

    docker run --rm -v .:/code -e PHPBIN=php7.4 ghcr.io/kasparsd/php-multitool:latest \
        parallel-lint .

## Credits

Created by [Kaspars Dambis](https://kaspars.net).