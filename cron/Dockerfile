FROM alpine:3.13
LABEL maintainer="Coding <code@ongoing.today>"

ENV SCRIPT_ROOT=/opt/rt
ENV USER=rt-service
ENV UID=1000
ENV GID=1000

RUN apk add --no-cache \
        certbot \
        dcron \
        postgresql-client && \
    mkdir -p ${SCRIPT_ROOT} && \
    addgroup \
        --gid "$GID" \
        "$USER" && \
    adduser \
        --disabled-password \
        --gecos "" \
        --home "$(pwd)" \
        --ingroup "$USER" \
        --no-create-home \
        --uid "$UID" \
        "$USER" && \
    mkdir -p /var/log/letsencrypt /var/lib/letsencrypt && \
    chown -R rt-service:rt-service /var/log/letsencrypt /var/lib/letsencrypt && \
    mkdir /backup && \
    chown rt-service:rt-service /backup && \
    touch /var/run/dcron.pid && \
    chown rt-service:rt-service /var/run/dcron.pid && \
    mkdir -p /var/spool/cron/cronstamps && \
    chown -R rt-service:rt-service /var/spool/cron && \
    chgrp rt-service /usr/bin/crontab && \
    cp /etc/crontabs/root /etc/crontabs/rt-service && \
    chown rt-service:rt-service /etc/crontabs/rt-service /etc/crontabs && \
    chown -R rt-service:rt-service /etc/periodic/

ADD dcron.sh ${SCRIPT_ROOT}
ADD certbot.sh /etc/periodic/daily/certbot
ADD pg_backup.sh /etc/periodic/daily/pg_backup

RUN chmod 0755 ${SCRIPT_ROOT}/dcron.sh && \
    chmod 0755 /usr/sbin/crond

USER "$USER"
CMD ["/opt/rt/dcron.sh", "-f", "-L", "/tmp/dcron.log"]
