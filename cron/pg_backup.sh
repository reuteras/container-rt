#!/bin/sh

export PGPASSWORD=$POSTGRES_PASSWORD

KEEP_DAYS=14

( pg_dump -h "$RT_DB_HOST" -U "$POSTGRES_USER" "$RT_DB_NAME" --table=sessions --schema-only; \
    pg_dump -h "$RT_DB_HOST" -U "$POSTGRES_USER" "$RT_DB_NAME" --exclude-table=sessions ) | \
    gzip > "/backup/rt-$(date +%Y%m%d).sql.gz"

find /backup -type f -name '*.gz' -mtime +$KEEP_DAYS -delete
