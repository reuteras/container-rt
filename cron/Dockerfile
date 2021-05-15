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
    chown -R ${USER}:${USER} /var/log/letsencrypt /var/lib/letsencrypt && \
    mkdir /backup && \
    echo "1 1 * * * ${SCRIPT_ROOT}/certbot.sh" > /tmp/new.cron && \
    crontab -u ${USER} /tmp/new.cron && \
    rm -f /tmp/new.cron && \
    chown ${USER}:${USER} /backup

ADD dcron.sh ${SCRIPT_ROOT}
ADD certbot.sh ${SCRIPT_ROOT}
ADD pg_backup.sh /etc/periodic/daily/pg_backup

RUN chmod 0755 ${SCRIPT_ROOT}/dcron.sh && \
    chmod 0755 /usr/sbin/crond

CMD ["/opt/rt/dcron.sh", "-f"]
