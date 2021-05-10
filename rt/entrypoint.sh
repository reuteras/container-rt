#!/bin/bash

for variable in POSTGRES_USER POSTGRES_PASSWORD RT_DB_HOST RT_USER RT_PASSWORD \
    RT_DB_NAME RT_DB_PORT RT_HOSTNAME RT_RELAYHOST RT_SENDER RT_DOMAIN RT_CERT_NAME; do
    if [[ -z  "${!variable}" ]]; then
        echo >&2 "You must specify \$$variable."
        exit 1
    fi
done

if ! grep "$RT_HOSTNAME" /etc/lighttpd/conf-available/89-rt.conf > /dev/null ; then
    cp /etc/lighttpd/conf-available/89-rt.conf /tmp/89-rt.conf
    sed -i -e "s=HOSTNAME=$RT_HOSTNAME=" /tmp/89-rt.conf
    cat /tmp/89-rt.conf > /etc/lighttpd/conf-available/89-rt.conf
    rm -f /tmp/89-rt.conf
fi

if ! grep "/etc/letsencrypt/live/$RT_HOSTNAME/fullchain.pem" /etc/lighttpd/conf-available/10-ssl.conf > /dev/null ; then
    cp /etc/lighttpd/conf-available/10-ssl.conf /tmp/10-ssl.conf
    sed -i "6 a ssl.ca-file = \"/etc/letsencrypt/live/$RT_HOSTNAME/fullchain.pem\"" \
        /tmp/10-ssl.conf
    cat /tmp/10-ssl.conf > /etc/lighttpd/conf-available/10-ssl.conf
    rm -f /tmp/10-ssl.conf
fi

if ! grep "/etc/letsencrypt/live/$RT_HOSTNAME/privkey.pem" /etc/lighttpd/conf-available/10-ssl.conf > /dev/null ; then
    cp /etc/lighttpd/conf-available/10-ssl.conf /tmp/10-ssl.conf
    sed -i "s#/etc/lighttpd/server.pem#/etc/letsencrypt/live/$RT_HOSTNAME/privkey.pem#" \
        /tmp/10-ssl.conf
    cat /tmp/10-ssl.conf > /etc/lighttpd/conf-available/10-ssl.conf
    rm -f /tmp/10-ssl.conf
fi

if ! grep "$RT_RELAYHOST" /etc/msmtprc > /dev/null ; then
    cp /etc/msmtprc /tmp/msmtprc
    sed -i -e "s=RT_RELAYHOST=$RT_RELAYHOST=" /tmp/msmtprc
    sed -i -e "s=RT_SENDER=$RT_SENDER=" /tmp/msmtprc
    sed -i -e "s=RT_DOMAIN=$RT_DOMAIN=" /tmp/msmtprc
    cat /tmp/msmtprc > /etc/msmtprc
    rm -f /tmp/msmtprc
fi

while ! pg_isready -q -h "$RT_DB_HOST" ; do
    echo "Waiting for database on $RT_DB_HOST to be ready."
    sleep 3
done

if ! PGPASSWORD="$RT_DB_PASS" psql -h "$RT_DB_HOST" -U "$RT_DB_USER" -lqt | cut -d \| -f 1 | grep -qw "$RT_DB_NAME" ; then
    echo "Setup database"
    /opt/rt5/sbin/rt-setup-database --dba="$POSTGRES_USER" --dba-password="$POSTGRES_PASSWORD" --action init 
    echo "Database setup done."
else
    echo "Check if database needs an upgrade."
    # /opt/rt5/sbin/rt-setup-database --action upgrade --dba="$POSTGRES_USER" --dba-password="$POSTGRES_PASSWORD"
fi

if [ ! -e "/etc/letsencrypt/live/$RT_HOSTNAME/privkey.pem" ]; then
    DNS_IP=""
    EXT_IP=""

    while [[ $EXT_IP == "" ]] ; do
        EXT_IP=$(curl -s https://icanhazip.com)
    done

    DNS_IP=$(dig @8.8.8.8 "$RT_HOSTNAME" | grep -v ';' | grep -v CNAME | grep A | awk '{print $5}')
    while [[ $EXT_IP != "$DNS_IP" ]]; do
        sleep 30
        DNS_IP=$(dig @8.8.8.8 "$RT_HOSTNAME" | grep -v ';' | grep -v CNAME | grep A | awk '{print $5}')
    done

    certbot certonly --standalone -m "$RT_SENDER" --agree-tos --no-eff-email -d "$RT_CERT_NAME" --force-renewal --non-interactive --http-01-port 8080
fi

exec "$@"
