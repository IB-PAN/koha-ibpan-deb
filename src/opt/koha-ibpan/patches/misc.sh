#!/bin/sh

# Don't include Zebra indexes in the backups
sed -iE 's/^koha-run-backups --days ([0-9]+) --output ([A-Za-z0-9/]+)$/koha-run-backups --days \1 --exclude-indexes --exclude-logs --output \2/' /etc/cron.daily/koha-common

# Update pre-compressed asset files for the web server
echo "Updating pre-compressed asset files for the web server..."
find /usr/share/koha/opac/htdocs/opac-tmpl/ -type f \
	-regex ".*\.\(zst\|br\|gz\)$" \
	-delete
find /usr/share/koha/opac/htdocs/opac-tmpl/ -type f -size +512c \
	-regex ".*\.\(css\|html\|js\|json\|map\|svg\|xml\|svg\|ico\|woff\|woff2\|ttf\|xsl\|xslt\|txt\)$" \
	-exec brotli --best {} \+ \
	-exec zstd -T0 -19 --force {} \+ \
	-exec gzip --best --keep --force {} \+
