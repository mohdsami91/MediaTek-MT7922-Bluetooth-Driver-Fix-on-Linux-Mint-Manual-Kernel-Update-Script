#!/bin/bash

echo "=== MediaTek MT7922 Bluetooth Fix Script ==="
echo "This script will attempt to enable Bluetooth support for MT7922"
echo ""

# Check current kernel version
echo "Current kernel version:"
uname -r
echo ""

# Check if MT7922 is detected
echo "Checking for MT7922 device..."
lspci | grep -i mediatek
echo ""

# Check current firmware
echo "Checking current bluetooth firmware..."
ls -la /lib/firmware/mediatek/ | grep BT_RAM_CODE_MT7922 2>/dev/null || echo "MT7922 Bluetooth firmware not found"
echo ""

# Update system packages
echo "Updating system packages..."
sudo apt update

# Install latest available kernel
echo "Installing latest kernel (this may take a while)..."
sudo apt install -y linux-generic-hwe-22.04

# Install latest firmware
echo "Installing latest firmware..."
sudo apt install -y linux-firmware

# Check if we need to manually download newer firmware
echo "Checking firmware version..."
if [ -f "/lib/firmware/mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin" ]; then
    echo "MT7922 Bluetooth firmware found"
else
    echo "Downloading latest MT7922 Bluetooth firmware..."
    
    # Create backup
    sudo cp -r /lib/firmware/mediatek /lib/firmware/mediatek.backup 2>/dev/null || true
    
    # Download latest firmware from kernel.org
    cd /tmp
    wget -q https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin
    
    if [ -f "BT_RAM_CODE_MT7922_1_1_hdr.bin" ]; then
        sudo cp BT_RAM_CODE_MT7922_1_1_hdr.bin /lib/firmware/mediatek/
        echo "Firmware updated successfully"
    else
        echo "Failed to download firmware"
    fi
fi

# Install Bluetooth packages
echo "Installing Bluetooth packages..."
sudo apt install -y bluez bluetooth bluez-tools

# Load the bluetooth module
echo "Loading Bluetooth modules..."
sudo modprobe btusb
sudo modprobe btintel
sudo modprobe btrtl
sudo modprobe btmtk

# Restart Bluetooth service
echo "Restarting Bluetooth service..."
sudo systemctl enable bluetooth
sudo systemctl restart bluetooth

# Check Bluetooth status
echo ""
echo "=== Final Status Check ==="
echo "Bluetooth service status:"
systemctl status bluetooth --no-pager -l

echo ""
echo "Bluetooth devices:"
bluetoothctl list 2>/dev/null || echo "No Bluetooth controllers found"

echo ""
echo "=== Next Steps ==="
echo "1. Reboot your system: sudo reboot"
echo "2. After reboot, check if Bluetooth is working: bluetoothctl list"
echo "3. If still not working, you may need to upgrade to Ubuntu 24.04 or Linux Mint 22"
echo "4. Alternative: Install a newer kernel manually (6.10+)"

echo ""
echo "Script completed. Please reboot your system."
