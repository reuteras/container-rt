#!/bin/sh -e

certbot renew
cat "/etc/letsencrypt/live/$RT_HOSTNAME/cert.pem" "/etc/letsencrypt/live/$RT_HOSTNAME/privkey.pem" > \
    "/etc/letsencrypt/live/$RT_HOSTNAME/server.pem"
