#!/bin/bash

# Ensure DNS resolvers are set
printf "nameserver 8.8.8.8\nnameserver 1.1.1.1\n" > /etc/resolv.conf

service cron start

/usr/sbin/apachectl -D FOREGROUND
