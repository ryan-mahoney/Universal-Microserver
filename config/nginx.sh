#!/bin/bash

# storage for ugc
mkdir -p /media/persistent/web
chown www-data /media/persistent/web --recursive
chgrp www-data /media/persistent/web --recursive

# web content permissions
chown www-data /app --recursive
chgrp www-data /app --recursive

# app logging
mkdir -p /media/persistent/log
chmod -R 0777 /media/persistent/log

/usr/sbin/nginx -g "daemon off;" |& /usr/bin/rotatelogs -n 3 /media/persistent/log/nginx.log 86400
