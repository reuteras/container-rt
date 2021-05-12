FROM alpine:3.13
LABEL maintainer="Coding <code@ongoing.today>"

ENV SCRIPT_ROOT=/opt/rt
ENV USER=rt-service
ENV UID=1000
ENV GID=1000

RUN apk add --no-cache \
        certbot \
        dcron && \
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
    chown -R rt-service:rt-service /var/log/letsencrypt /var/lib/letsencrypt

ADD dcron.sh ${SCRIPT_ROOT}
ADD certbot.sh /etc/periodic/daily/certbot

RUN chmod 0755 ${SCRIPT_ROOT}/dcron.sh && \
    chmod 0755 /usr/sbin/crond

USER "$USER"
CMD ["/opt/rt/dcron.sh", "-f"]
