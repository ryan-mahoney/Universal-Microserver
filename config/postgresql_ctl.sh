#!/bin/bash

# wait for init to finish
sleep 5

# this script is run by Supervisor to start PostgreSQL in foreground mode
function shutdown()
{
    echo "Shutting down PostgreSQL"
    pkill postgres
}

if [ -d /var/run/postgresql ]; then
    chmod 2775 /var/run/postgresql
else
    install -d -m 2775 -o postgres -g postgres /var/run/postgresql
fi

# allow any signal which would kill a process to stop PostgreSQL
trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP

# check if database was already initialized
if [ ! -d "/media/persistent/pgsql" ]; then
    mkdir -p /media/persistent/pgsql
    mkdir -p /media/persistent/pgsql/data
    chown postgres /media/persistent/pgsql --recursive
    chgrp postgres /media/persistent/pgsql --recursive
    chmod 700 /media/persistent/pgsql/data
    runuser postgres -c '/usr/lib/postgresql/9.6/bin/initdb -E UTF8 -D "/media/persistent/pgsql/data"'
fi

chmod -R 0700 /media/persistent/pgsql/data

# run postgres server as postgres user
runuser postgres -c '/usr/lib/postgresql/9.6/bin/postgres -D "/media/persistent/pgsql/data"'
