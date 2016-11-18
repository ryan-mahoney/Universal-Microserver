#!/bin/bash

# app logging
mkdir -p /media/persistent/log
chmod -R 0777 /media/persistent/log

if [ $OPINE_ENV = "local" ]
    then
        cd /app/frontend && npm install
        cd /app/frontend && nodemon server.js --watch /home/app/frontend --exec babel-node --presets es2015,stage-2 |& /usr/bin/rotatelogs -n 3 /media/persistent/log/nodejs.log 86400
    else
        cd /app/frontend && nodemon dist/server.js --watch false |& /usr/bin/rotatelogs -n 3 /media/persistent/log/nodejs.log 86400
fi
