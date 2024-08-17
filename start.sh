#!/bin/sh
service cron start & tail -f /var/log/cron-2.log
/usr/sbin/apachectl -D FOREGROUND
sh runcommand.sh www
