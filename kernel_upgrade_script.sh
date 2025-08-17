#!/bin/bash

echo "=== Manual Kernel Upgrade Script for MT7922 Support ==="
echo "WARNING: This will install a newer kernel. Make sure you have backups!"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Add Ubuntu mainline kernel PPA (for newer kernels)
echo "Adding Ubuntu mainline kernel repository..."
sudo add-apt-repository -y ppa:cappelikan/ppa
sudo apt update

# Install mainline kernel tool
sudo apt install -y mainline

echo ""
echo "Available kernels with MT7922 support (6.10+):"
echo "You can use 'sudo mainline --install-latest' to install the latest stable kernel"
echo "Or use 'mainline --list' to see available versions"

echo ""
echo "Manual installation steps:"
echo "1. Run: sudo mainline --list"
echo "2. Choose a kernel version 6.10 or higher"
echo "3. Run: sudo mainline --install <version>"
echo "4. Reboot"

echo ""
echo "Alternative manual download method:"
echo "Visit: https://kernel.ubuntu.com/mainline/"
echo "Download kernel 6.10+ .deb files for your architecture"
echo "Install with: sudo dpkg -i *.deb"

# Check current kernel
echo ""
echo "Current kernel: $(uname -r)"
echo "You need kernel 6.10 or higher for MT7922 Bluetooth support"
