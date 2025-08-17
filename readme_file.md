# MediaTek MT7922 Bluetooth Fix for Linux

> 🔧 **Complete solution for MediaTek MT7922 Bluetooth connectivity issues on Linux systems**

## 📋 Table of Contents

- [Problem Description](#-problem-description)
- [Quick Fix](#-quick-fix)
- [Scripts Included](#-scripts-included)
- [Manual Solutions](#-manual-solutions)
- [Supported Hardware](#-supported-hardware)
- [Installation](#-installation)
- [Usage](#-usage)
- [Troubleshooting](#-troubleshooting)
- [Educational Resources](#-educational-resources)
- [Contributing](#-contributing)
- [License](#-license)

## 🚨 Problem Description

Many modern laptops ship with **MediaTek MT7922** wireless adapters that combine WiFi and Bluetooth functionality. While WiFi typically works out-of-the-box on Linux distributions, **Bluetooth often fails** with these symptoms:

### Common Issues:
- ❌ **"No default controller available"** in `bluetoothctl`
- ❌ No Bluetooth option in system settings
- ❌ Empty output from `bluetoothctl list`
- ❌ Hardware detected by `lsusb` but non-functional Bluetooth
- ❌ Bluetooth works intermittently or stops after suspend

### Root Causes:
- Missing or incorrect Bluetooth firmware
- Improper driver binding (btusb/btmtk)
- USB power management issues
- Wrong kernel module loading order
- Outdated Linux kernel (<6.10)

## 🚀 Quick Fix

### Prerequisites
```bash
# Check your hardware
lsusb | grep -i mediatek
lspci | grep -i mediatek

# Check kernel version (6.10+ recommended)
uname -r
```

### One-Command Fix
```bash
wget -O - https://raw.githubusercontent.com/mohdsami91/mt7922-bluetooth-fix/main/bluetooth_troubleshoot_script.sh | bash
```

Or download and run manually:

```bash
git clone https://github.com/mohdsami91/mt7922-bluetooth-fix.git
cd mt7922-bluetooth-fix
chmod +x bluetooth_troubleshoot_script.sh
./bluetooth_troubleshoot_script.sh
```

## 📄 Scripts Included

### 1. `bluetooth_troubleshoot_script.sh`
**Main fix script** - Comprehensive automated solution

**Features:**
- ✅ Hardware detection and validation
- ✅ Automatic firmware download and installation
- ✅ Module loading and service restart
- ✅ USB power management fixes
- ✅ RFKILL unblocking
- ✅ Status verification and reporting

**Usage:**
```bash
./bluetooth_troubleshoot_script.sh
```

### 2. `bluetooth_diagnostic_commands.sh`
**Advanced diagnostics** - Deep hardware and driver analysis

**Features:**
- 🔍 Detailed hardware detection
- 🔍 Driver binding analysis
- 🔍 Firmware status checking
- 🔍 USB interface examination
- 🔍 Kernel message analysis

**Usage:**
```bash
./bluetooth_diagnostic_commands.sh
```

### 3. `mt7922_bluetooth_fix.sh`
**Legacy fix script** - Basic firmware and module management

**Usage:**
```bash
./mt7922_bluetooth_fix.sh
```

### 4. `kernel_upgrade_script.sh`
**Kernel upgrade helper** - For systems with older kernels

**Usage:**
```bash
./kernel_upgrade_script.sh
```

## 🛠️ Manual Solutions

If scripts don't work, try these manual fixes:

### Fix 1: Force Driver Binding
```bash
# Get your device Product ID
lsusb | grep -i mediatek

# Force bind to btusb driver (replace XXXX with your product ID)
echo '0e8d XXXX' | sudo tee /sys/bus/usb/drivers/btusb/new_id
```

### Fix 2: Manual Firmware Installation
```bash
# Download latest firmware
cd /tmp
wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin

# Install firmware
sudo mkdir -p /lib/firmware/mediatek
sudo cp BT_RAM_CODE_MT7922_1_1_hdr.bin /lib/firmware/mediatek/

# Reload modules
sudo modprobe -r btusb btmtk
sudo modprobe btmtk
sudo modprobe btusb
```

### Fix 3: USB Power Management
```bash
# Disable USB auto-suspend for MediaTek devices
for device in /sys/bus/usb/devices/*/idVendor; do
    if [ -f "$device" ] && [ "$(cat $device)" = "0e8d" ]; then
        echo 'on' | sudo tee $(dirname $device)/power/control
    fi
done
```

### Fix 4: Module Loading Order
```bash
# Load modules in correct order
sudo modprobe -r btusb btmtk btintel btrtl
sudo modprobe bluetooth
sudo modprobe btmtk
sudo modprobe btusb
sudo systemctl restart bluetooth
```

## 🖥️ Supported Hardware

| Device | Vendor ID | Product ID | Status |
|--------|-----------|------------|---------|
| MT7922 | 0e8d | 7961 | ✅ Supported |
| MT7922 | 0e8d | 7922 | ✅ Supported |
| MT7921 | 0e8d | 7961 | ⚠️ Limited |

### Tested Systems:
- **Linux Mint 21.3+** ✅
- **Ubuntu 22.04+** ✅
- **Pop!_OS 22.04+** ✅
- **Kernel 6.14+** ✅ (Full support)
- **Kernel 6.10-6.13** ⚠️ (Partial support)
- **Kernel <6.10** ❌ (Not supported)

## 📦 Installation

### Clone Repository
```bash
git clone https://github.com/mohdsami91/mt7922-bluetooth-fix.git
cd mt7922-bluetooth-fix
```

### Make Scripts Executable
```bash
chmod +x *.sh
```

## 🎮 Usage

### Step 1: Run Diagnostics (Optional)
```bash
./bluetooth_diagnostic_commands.sh
```
This will show detailed information about your hardware and help identify specific issues.

### Step 2: Apply Main Fix
```bash
./bluetooth_troubleshoot_script.sh
```
This script will attempt to fix most common issues automatically.

### Step 3: Reboot
```bash
sudo reboot
```

### Step 4: Test Bluetooth
```bash
# Check if controller is detected
bluetoothctl list

# Start scanning for devices
bluetoothctl
power on
agent on
default-agent
scan on
```

## 🔧 Troubleshooting

### Still Not Working?

1. **Check kernel version:**
   ```bash
   uname -r
   # If < 6.10, run: ./kernel_upgrade_script.sh
   ```

2. **Verify hardware detection:**
   ```bash
   lsusb | grep -i mediatek
   dmesg | grep -i bluetooth | tail -10
   ```

3. **Check firmware loading:**
   ```bash
   dmesg | grep -i firmware
   ls -la /lib/firmware/mediatek/
   ```

4. **Manual USB reset:**
   ```bash
   sudo usb_modeswitch -v 0e8d -p XXXX --reset-usb
   ```

### Common Error Messages:

| Error | Solution |
|-------|----------|
| "No default controller available" | Run `bluetooth_troubleshoot_script.sh` |
| "Operation not permitted" | Check RFKILL: `sudo rfkill unblock all` |
| "Firmware loading failed" | Manual firmware installation (see above) |
| "Device not found" | USB power management fix |

## 📚 Educational Resources

This repository also includes educational materials for understanding Linux Bluetooth driver development:

### Driver Development Template
- `mt7922_bluetooth.c` - Basic driver structure (educational only)
- `Makefile` - Build system for kernel modules
- Driver development documentation

**⚠️ Note:** These are for learning purposes only. For production use, always use the existing `btmtk` kernel driver.

### Learning Resources:
- [Linux Kernel Bluetooth Subsystem](https://www.kernel.org/doc/html/latest/networking/bluetooth.html)
- [USB Driver Development](https://www.kernel.org/doc/html/latest/driver-api/usb/index.html)
- [MediaTek MT7922 Specifications](https://www.mediatek.com/)

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### Reporting Issues
1. Run `./bluetooth_diagnostic_commands.sh`
2. Create an issue with the full output
3. Include your system information:
   ```bash
   uname -a
   lsb_release -a
   lsusb | grep -i mediatek
   ```

### Adding Support for New Hardware
1. Fork the repository
2. Test scripts on your hardware
3. Update hardware compatibility table
4. Submit a pull request

### Code Contributions
1. Follow existing script structure
2. Add error handling and logging
3. Test on multiple distributions
4. Update documentation

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Linux kernel developers working on MediaTek support
- Community members who reported and tested fixes
- MediaTek 