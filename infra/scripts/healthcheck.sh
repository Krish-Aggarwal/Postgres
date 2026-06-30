#!/bin/bash

set -e

echo "======================================="
echo " PostgreSQL Cluster Health Check"
echo "======================================="

BASE_DIR="$(pwd)"
INVENTORY="$BASE_DIR/ansible/inventory.ini"

echo "Using inventory: $INVENTORY"

echo ""
echo "Checking service status..."
echo "--------------------------------------"

for node in primary sync_standby async_standby
do
    echo ""
    echo "Node: $node"

    ansible "$node" \
        -i "$INVENTORY" \
        -b \
        -m shell \
        -a "systemctl is-active postgresql@17-main"
done

echo ""
echo "Checking replication..."
echo "--------------------------------------"

ansible primary \
    -i "$INVENTORY" \
    -b \
    -m shell \
    -a "sudo -u postgres psql -c \"SELECT client_addr, state, sync_state FROM pg_stat_replication;\""

echo ""
echo "Health check completed"
