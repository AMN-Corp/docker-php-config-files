#!/bin/sh
service cron start
/usr/sbin/apachectl -D FOREGROUND
/var/www/html/runcommand.sh www
