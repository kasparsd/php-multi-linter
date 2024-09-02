#!/bin/sh
set -e

# Set the PHP binary alias.
if [ ! -z "${PHPBIN}" ]; then
	if test -f "/usr/bin/${PHPBIN}"; then
		update-alternatives --quiet --set php "/usr/bin/${PHPBIN}"
	else
		echo "PHP binary /usr/bin/${PHPBIN} not found."
		exit 1
	fi
fi

exec "$@"