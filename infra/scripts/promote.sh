#!/bin/bash

set -e

echo "Promoting Sync Standby..."

sudo -u postgres psql -c "SELECT pg_promote(wait_seconds => 60);"

sleep 10

echo

sudo -u postgres psql -c "SELECT pg_is_in_recovery();"

echo

echo "Node promoted successfully."
