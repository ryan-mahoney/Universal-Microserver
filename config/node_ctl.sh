#!/bin/bash

# wait for init to finish
sleep 5
cd /app/frontend

if [ $OPINE_ENV = "local" ]
    then
        npm install
        nodemon server.js --watch /home/app/frontend --exec babel-node --presets es2015,stage-0,stage-2,react
    else
        node dist/server.js
fi
