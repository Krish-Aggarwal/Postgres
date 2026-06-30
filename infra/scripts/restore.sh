#!/bin/bash
set -euo pipefail

BACKUP_PATH="${1:-}"

if [[ -z "$BACKUP_PATH" ]]; then
    echo "Usage: ./restore.sh /path/to/basebackup.tar.gz"
    exit 1
fi

if [[ ! -f "$BACKUP_PATH" ]]; then
    echo "ERROR: Backup file not found: $BACKUP_PATH"
    exit 1
fi

echo "===================================="
echo " PostgreSQL DR Restore Starting"
echo "===================================="

echo "[1/5] Stopping PostgreSQL..."
sudo systemctl stop postgresql@17-main || true

echo "[2/5] Cleaning data directory..."
sudo rm -rf /var/lib/postgresql/17/main/*

echo "[3/5] Restoring base backup..."
sudo tar -xzf "$BACKUP_PATH" -C /var/lib/postgresql/17/main

echo "[4/5] Setting permissions..."
sudo chown -R postgres:postgres /var/lib/postgresql/17/main

echo "[5/5] Creating standby configuration..."

# If this node is NOT primary, force standby mode
touch /var/lib/postgresql/17/main/standby.signal

echo "primary_conninfo = 'host=PRIMARY_IP port=5432 user=replicator password=replica_pass'" \
  | sudo tee -a /var/lib/postgresql/17/main/postgresql.auto.conf

echo "Starting PostgreSQL..."
sudo systemctl start postgresql@17-main

sleep 5

echo "Checking status..."
sudo systemctl status postgresql@17-main --no-pager || true

echo ""
echo "Restore completed successfully"
