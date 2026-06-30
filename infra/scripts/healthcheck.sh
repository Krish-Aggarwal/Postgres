#!/bin/bash

set -e

echo "======================================="
echo " PostgreSQL Cluster Health Check"
echo "======================================="

echo
echo "Checking PostgreSQL Service..."
systemctl is-active postgresql@17-main

echo
echo "Checking PostgreSQL Connectivity..."
sudo -u postgres psql -c "SELECT now();"

echo
echo "Checking Recovery Mode..."
sudo -u postgres psql -t -c "SELECT pg_is_in_recovery();"

echo
echo "Checking Replication Status..."

RECOVERY=$(sudo -u postgres psql -t -A -c "SELECT pg_is_in_recovery();")

if [ "$RECOVERY" = "f" ]; then

    echo "This is PRIMARY"

    sudo -u postgres psql -c "
    SELECT
        client_addr,
        application_name,
        state,
        sync_state
    FROM pg_stat_replication;
    "

else

    echo "This is STANDBY"

    sudo -u postgres psql -c "
    SELECT
        status,
        receive_start_lsn,
        received_lsn,
        latest_end_lsn
    FROM pg_stat_wal_receiver;
    "

fi

echo
echo "Disk Usage"

df -h

echo
echo "Memory"

free -m

echo
echo "Health Check Completed Successfully"
