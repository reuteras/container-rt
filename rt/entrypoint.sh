#!/bin/bash

if [[ -z  "$RT_HOSTNAME" ]]; then
    echo >&2 "You must specify RT_HOSTNAME."
    exit 1
fi

if [[ -z  "$RT_RELAYHOST" ]]; then
    echo >&2 "You must specify RT_RELAYHOST."
    exit 1
fi

cp /etc/lighttpd/conf-available/89-rt.conf /tmp/89-rt.conf
sed -i -e "s=HOSTNAME=$RT_HOSTNAME=" /tmp/89-rt.conf
cat /tmp/89-rt.conf > /etc/lighttpd/conf-available/89-rt.conf

sed -i -e "s=RT_DB_HOST=$RT_DB_HOST=" /opt/rt5/etc/RT_SiteConfig.pm
sed -i -e "s=RT_DB_PORT=$RT_DB_PORT=" /opt/rt5/etc/RT_SiteConfig.pm
sed -i -e "s=RT_DB_USER=$RT_DB_USER=" /opt/rt5/etc/RT_SiteConfig.pm
sed -i -e "s=RT_DB_PASS=$RT_DB_PASS=" /opt/rt5/etc/RT_SiteConfig.pm

while ! pg_isready -q -h "$RT_DB_HOST" ; do
    echo "Waiting for database on $RT_DB_HOST to be ready."
    sleep 3
done

if ! PGPASSWORD="$RT_DB_PASS" psql -h "$RT_DB_HOST" -U "$RT_DB_USER" -lqt | cut -d \| -f 1 | grep -qw rtdb ; then
    echo "setup db"
    /opt/rt5/sbin/rt-setup-database --dba=postgres --dba-password=postgres --action init 
fi

exec "$@"
