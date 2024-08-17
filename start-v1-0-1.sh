#!/bin/bash

service cron start

/usr/sbin/apachectl -D FOREGROUND

ping 127.0.0.1 -n 10 > nul

whoami

base_link=/var/www/html

echo ${base_link}

if [ -e ${base_link} ]; then
    cd ${base_link}
    pwd

    chmod -R 755 ${base_link}
     chown -R root:root ${base_link}
    chmod -R 775 ${base_link}/bootstrap
     chown -R root:www-data ${base_link}/bootstrap/
    chmod -R 755 ${base_link}/public
     chown -R root:www-data ${base_link}/public/
    chmod -R 444 ${base_link}/public/index.php
     chown -R root:root ${base_link}/public/.htaccess
    chmod -R 444 ${base_link}/public/.htaccess
    chmod -R 775 ${base_link}/storage/
     chown -R www-data:www-data ${base_link}/storage/
    chmod -R 775 ${base_link}/public/uploads
    chmod -R 775 ${base_link}/storage/app/public/

    rm ${base_link}/storage/app/public/*.php
    rm ${base_link}/storage/app/public/document/*.php
    rm ${base_link}/public/uploads/*.php
    rm ${base_link}/public/uploads/product/*.php
    rm ${base_link}/public/uploads/signature/*.php

    cd ${base_link}
     composer install --working-dir ${base_link}

    rm -r ${base_link}/bootstrap/cache/*
    rm -r ${base_link}/storage/framework/cache/data/*
    rm -r ${base_link}/storage/framework/sessions/*
    rm -r ${base_link}/storage/framework/views/*
    rm -r ${base_link}/storage/logs/apache2handler/*
    rm -r ${base_link}/storage/logs/cli/*

    cd ${base_link}
    storage_link=${base_link}/public/storage

    if [ -L ${storage_link} ]; then
        if [ -e ${storage_link} ]; then
            echo "Good link"
        else
            echo "Broken link"
            unlink ${storage_link}
             php ${base_link}/artisan storage:link
        fi
    elif [ -e ${storage_link} ]; then
        echo "Not a link"
        rm -r ${storage_link}
         php ${base_link}/artisan storage:link
    else
        echo "Missing"
         php ${base_link}/artisan storage:link
    fi

    cd ${base_link}
     composer dump-autoload --working-dir ${base_link}

     php ${base_link}/artisan optimize
     php ${base_link}/artisan cache:clear
     php ${base_link}/artisan route:cache
     php ${base_link}/artisan route:clear
     php ${base_link}/artisan view:clear
     php ${base_link}/artisan config:cache
     php ${base_link}/artisan config:clear
     php ${base_link}/artisan clear-compiled

    echo "Done"
else
    echo "Invalid base link"
fi


