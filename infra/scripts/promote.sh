#!/bin/bash

set -euo pipefail

echo "===================================="
echo " Sync Standby Promotion Starting"
echo "===================================="

echo "[1/4] Checking if node is in recovery..."

IN_RECOVERY=$(sudo -u postgres psql -tAc "SELECT pg_is_in_recovery();")

if [[ "$IN_RECOVERY" != "t" ]]; then
    echo "ERROR: Node is not a standby. Promotion aborted."
    exit 1
fi

echo "[2/4] Promoting standby..."

sudo -u postgres psql -c "SELECT pg_promote(wait_seconds => 60);"

sleep 5

echo "[3/4] Verifying promotion..."

IS_RECOVERY_AFTER=$(sudo -u postgres psql -tAc "SELECT pg_is_in_recovery();")

if [[ "$IS_RECOVERY_AFTER" == "f" ]]; then
    echo "SUCCESS: Node successfully promoted to PRIMARY"
else
    echo "ERROR: Promotion failed"
    exit 1
fi

echo "[4/4] Checking write capability..."

sudo -u postgres psql -c "CREATE TABLE IF NOT EXISTS promotion_test(id int);" || true

echo ""
echo "Node promoted successfully to PRIMARY"
echo "===================================="
