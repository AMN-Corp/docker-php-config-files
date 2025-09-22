#!/bin/bash

service cron start

/usr/sbin/apachectl -D FOREGROUND
