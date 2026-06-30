#!/bin/bash

set -e

BACKUP_DIR=$1

if [ -z "$BACKUP_DIR" ]; then
    echo "Usage:"
    echo "./restore.sh /backup/2026-06-29"
    exit 1
fi

echo "Stopping PostgreSQL..."

sudo systemctl stop postgresql@17-main

echo "Cleaning old data..."

sudo rm -rf /var/lib/postgresql/17/main/*

echo "Restoring Backup..."

sudo tar -xzf "$BACKUP_DIR/basebackup.tar.gz" \
    -C /var/lib/postgresql/17/main

sudo chown -R postgres:postgres /var/lib/postgresql/17/main

echo "Starting PostgreSQL..."

sudo systemctl start postgresql@17-main

sleep 5

echo

sudo -u postgres psql -c "SELECT version();"

echo

echo "Restore Completed Successfully"
