#!/bin/bash

# Minimal USB-Ethernet Auto-Share Script for Radxa CM5
set -e

# Find USB-ethernet device (starts with 'enx')
USB_DEVICE=$(ip link show | grep -o 'enx[a-f0-9]\{12\}' | head -1)

if [[ -z "$USB_DEVICE" ]]; then
    echo "No USB-ethernet device found"
    exit 1
fi

CONNECTION_NAME="USB-Share-$USB_DEVICE"

echo "Setting up shared connection for $USB_DEVICE"

# Remove existing connection if it exists
nmcli connection delete "$CONNECTION_NAME" 2>/dev/null || true

# Create and activate shared connection
nmcli connection add \
    type ethernet \
    con-name "$CONNECTION_NAME" \
    ifname "$USB_DEVICE" \
    ip4 192.168.42.1/24 \
    ipv4.method shared

nmcli connection up "$CONNECTION_NAME"

echo "✓ Sharing setup complete - CM5 should get IP 192.168.42.2+"
