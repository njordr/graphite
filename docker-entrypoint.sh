#!/bin/bash


sed -i "s/\('USER': '\)[^']*/\1$DBUSER/" /etc/graphite/local_settings.py
sed -i "s/\('PASSWORD': '\)[^']*/\1$DBPASSWORD/" /etc/graphite/local_settings.py
sed -i "s/\('HOST': '\)[^']*/\1$DBHOST/" /etc/graphite/local_settings.py
sed -i "s/\('PORT': '\)[^']*/\1$DBPORT/" /etc/graphite/local_settings.py
sed -i "s/\('NAME': '\)[^']*/\1$DBNAME/" /etc/graphite/local_settings.py

if [ $ENGINE == "mysql" ]; then
    sed -i "s/\('ENGINE': '\)[^']*/\1django.db.backends.mysql/" /etc/graphite/local_settings.py
elif [ $ENGINE == "postgres" ]; then
    sed -i "s/\('ENGINE': '\)[^']*/\1django.db.backends.postgresql_psycopg2/" /etc/graphite/local_settings.py
fi

if [ ! -z $FIRSTRUN ]; then
    graphite-manage syncdb --noinput
fi

chown -R _graphite._graphite /var/lib/graphite

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
