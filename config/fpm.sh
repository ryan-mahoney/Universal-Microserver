#!/bin/bash

# app logging
mkdir -p /media/persistent/log
chmod -R 0777 /media/persistent/log

/usr/sbin/php-fpm7.0 --nodaemonize --force-stderr |& /usr/bin/rotatelogs -n 3 /media/persistent/log/fpm.log 86400
