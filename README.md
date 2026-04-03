# SUSFS Logic Patches for Non-GKI Kernels (4.14)

[![Telegram](https://img.shields.io/badge/Telegram-@bitcockiii-26A5E4?style=for-the-badge&logo=telegram)](https://t.me/bitcockiii)
[![GitHub](https://img.shields.io/badge/GitHub-mafiadan6-181717?style=for-the-badge&logo=github)](https://github.com/mafiadan6)
[![Kernel](https://img.shields.io/badge/Kernel-4.14-blue?style=for-the-badge)]()
[![SUSFS](https://img.shields.io/badge/SUSFS-v2.1.0-green?style=for-the-badge)]()

---

## 📖 Overview

Enhanced SUSFS logic patches adapted for **non-GKI kernels** (4.14). These patches bring the full SUSFS feature set from the Super-Builders GKI project to non-GKI devices, enabling advanced root hiding, path redirection, and detection evasion.

**Built into this kernel:**
- ✅ **SUSFS** (v2.1.0) — Kernel-level hiding and spoofing
- ✅ **ZeroMount** — VFS driver for filesystem redirection

**Required userspace module:**
- 📦 **[ZeroMount Module](https://github.com/Enginex0/Super-Builders)** — Must be installed in your root manager (KernelSU/APatch/Magisk) to manage SUSFS rules and ZeroMount operations

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| **Path Hiding** | Hide sensitive files/directories from detection apps |
| **Maps Hiding** | Hide memory mappings from `/proc/[pid]/maps` |
| **Kstat Spoofing** | Spoof file metadata (inode, size, timestamps) |
| **Kstat Redirect** | Redirect kstat lookups to real file metadata |
| **Unicode Filter** | Block filesystem path attacks using unicode characters |
| **Hidden Names** | Auto-hide Android/data and Android/obb package directories |
| **Open Redirect** | Redirect file open() calls at kernel level (no mounts needed) |
| **Hardened SUSFS** | Upstream bug fixes for concurrency and error handling |

---

## 📦 Installation

### Prerequisites
- Kernel source tree based on **Android 4.14**
- Base SUSFS already integrated (`CONFIG_KSU_SUSFS=y`)
- KernelSU (ReSukiSU/SukiSU-Ultra) integrated
- ZeroMount built into kernel

### Apply Patches

**Option 1: Wrapper Script (Recommended)**
```bash
cd /path/to/SUSFS-NonGKI-Patches
./apply_patches.sh /path/to/your/kernel/source
```

**Option 2: Manual**
```bash
cd /path/to/your/kernel/source
for patch in /path/to/SUSFS-NonGKI-Patches/patches/*.patch; do
    patch -p1 < "$patch"
done
```

### Enable Config Options
Ensure your defconfig or menuconfig includes:
```
CONFIG_KSU_SUSFS_SUS_KSTAT_REDIRECT=y
CONFIG_KSU_SUSFS_UNICODE_FILTER=y
CONFIG_KSU_SUSFS_HIDDEN_NAME=y
CONFIG_KSU_SUSFS_HARDENED=y
```

### Build & Flash
```bash
# Build your kernel
make -j$(nproc --all)

# Flash the resulting boot image to your device
fastboot flash boot boot.img
```

### Install ZeroMount Module
After flashing and rebooting, install the **ZeroMount module** in your root manager:
1. Download the latest [ZeroMount module](https://github.com/Enginex0/Super-Builders)
2. Flash it via KernelSU/APatch/Magisk module installer
3. Reboot
4. Configure via ZeroMount WebUI

### Verify
```sh
su -c 'zeromount detect'
```
Expected output should show `susfs: true` with all features detected.

---

## 📂 Patch Structure

```
patches/
├── 01-kernel-reboot-supercall-fix.patch     # SUSFS supercall routing fix
├── 02-fs-Kconfig-susfs-enhancements.patch   # New Kconfig options
├── 03-fs-namei-susfs-hooks.patch            # Unicode filter + hidden name
├── 04-fs-stat-susfs.patch                   # stat SUSFS checks
├── 05-fs-open-susfs.patch                   # faccessat hidden name
├── 06-fs-readdir-susfs.patch                # readdir helper replacement
├── 07-fs-fdinfo-hardened.patch              # Hardened fixes
└── 08-fs-statfs-susfs.patch                 # statfs fix
```

---

## 🙏 Credits & Acknowledgments

| Project/Person | Contribution |
|----------------|-------------|
| **[SUSFS](https://gitlab.com/simonpunk/susfs4ksu)** by **simonpunk** | Kernel-level hiding and spoofing framework |
| **[NonGKI Kernel Build](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd)** by **JackA1ltman** | Base SUSFS 2.1.0 patches adapted for non-GKI kernels |
| **[Super-Builders](https://github.com/Enginex0/Super-Builders)** by **Enginex0** | Original GKI SUSFS logic patches, ZeroMount module, and BRENE integration |
| **[KernelSU](https://github.com/tiann/KernelSU)** by **tiann** | Kernel-based root solution |
| **[ZeroMount](https://github.com/Enginex0/Super-Builders)** by **Enginex0** | VFS driver and mount management |
| **mafiadan6** | Non-GKI 4.14 adaptation, supercall fix, and patch integration |

---

## 📞 Support

- **Telegram:** [@bitcockiii](https://t.me/bitcockiii)
- **GitHub:** [mafiadan6](https://github.com/mafiadan6)

---

## ⚠️ Disclaimer

```
This software is provided "as is", without warranty of any kind.
Use at your own risk. The author is not responsible for any damage
to your device, data loss, or bricked devices.

These patches are intended for educational and research purposes.
Ensure you comply with local laws and regulations when using
root hiding tools.
```

---

## 📄 License

Patches are provided under the same license as the original SUSFS project.
See the [Super-Builders repository](https://github.com/Enginex0/Super-Builders) for details.
