#!/bin/bash

# Ensure DNS resolvers are set (Docker internal DNS first, then public DNS as fallback)
printf "nameserver 127.0.0.11\nnameserver 8.8.8.8\nnameserver 1.1.1.1\n" > /etc/resolv.conf

service cron start

/usr/sbin/apachectl -D FOREGROUND
