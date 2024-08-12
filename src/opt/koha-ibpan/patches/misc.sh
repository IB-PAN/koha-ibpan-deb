#!/bin/sh

sed -i 's/koha-run-backups --days 2 --output/koha-run-backups --days 2 --exclude-indexes --output/' /etc/cron.daily/koha-common
