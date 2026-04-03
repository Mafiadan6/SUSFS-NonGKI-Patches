#!/bin/bash
#
# SUSFS Non-GKI Patch Wrapper
# Applies all SUSFS logic patches for non-GKI kernels (4.14)
# Author: mafiadan6 (@bitcockiii)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCHES_DIR="$SCRIPT_DIR/patches"
KERNEL_DIR="${1:-.}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   SUSFS Non-GKI Patch Installer v1.0    ║${NC}"
echo -e "${BLUE}║   by mafiadan6 (@bitcockiii)            ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
echo ""

# Check if kernel directory exists
if [ ! -d "$KERNEL_DIR" ]; then
    echo -e "${RED}✗ Error: Kernel directory '$KERNEL_DIR' not found${NC}"
    echo -e "${YELLOW}Usage: $0 [path_to_kernel_source]${NC}"
    exit 1
fi

# Check if patches directory exists
if [ ! -d "$PATCHES_DIR" ]; then
    echo -e "${RED}✗ Error: Patches directory not found at $PATCHES_DIR${NC}"
    exit 1
fi

# Count patches
PATCH_COUNT=$(ls "$PATCHES_DIR"/*.patch 2>/dev/null | wc -l)
if [ "$PATCH_COUNT" -eq 0 ]; then
    echo -e "${RED}✗ Error: No patches found in $PATCHES_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Found $PATCH_COUNT patches${NC}"
echo -e "${YELLOW}  Target: $KERNEL_DIR${NC}"
echo ""

# Ask for confirmation
read -p "Apply patches? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Aborted.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}Applying patches...${NC}"
echo ""

# Apply each patch
FAILED=0
for patch in "$PATCHES_DIR"/*.patch; do
    patch_name=$(basename "$patch")
    echo -ne "  ${YELLOW}→${NC} $patch_name ... "
    
    if patch -p1 -d "$KERNEL_DIR" --dry-run < "$patch" > /dev/null 2>&1; then
        patch -p1 -d "$KERNEL_DIR" < "$patch" > /dev/null 2>&1
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ (failed or already applied)${NC}"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   All patches applied successfully!      ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Enable config options in your defconfig:"
    echo "     CONFIG_KSU_SUSFS_SUS_KSTAT_REDIRECT=y"
    echo "     CONFIG_KSU_SUSFS_UNICODE_FILTER=y"
    echo "     CONFIG_KSU_SUSFS_HIDDEN_NAME=y"
    echo "     CONFIG_KSU_SUSFS_HARDENED=y"
    echo "  2. Build your kernel"
    echo "  3. Flash and reboot"
    echo "  4. Install ZeroMount module in your root manager"
    echo "  5. Verify: su -c 'zeromount detect'"
else
    echo -e "${RED}╔══════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   $FAILED patch(es) failed to apply          ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Some patches may have already been applied.${NC}"
    echo -e "${YELLOW}Check the output above for details.${NC}"
fi

echo ""
