#!/bin/bash

# ==========================================
# Script: Permission Fixer
# Description: Resets file/folder permissions to safe defaults.
#              Directories -> 755 (rwxr-xr-x)
#              Files       -> 644 (rw-r--r--)
# ==========================================

# 1. Source Configuration
source "$(dirname "$0")/../config.conf"

# 2. Check for Root Privileges
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

echo "--- Fix File Permissions ---"
echo "This will reset permissions recursively:"
echo "  * Directories: 755 (Owner: RWX, Group: R-X, Others: R-X)"
echo "  * Files:       644 (Owner: RW-, Group: R--, Others: R--)"

# 3. Get Directory Input
read -p "Enter the full directory path to fix (e.g., /var/www/html): " TARGET_DIR

# 4. Validate Input
if [ -z "$TARGET_DIR" ]; then
    echo "Error: Path cannot be empty."
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# 5. Confirm Action
echo "WARNING: You are about to change permissions for ALL files in:"
echo "   $TARGET_DIR"
read -p "Are you sure? (y/n): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo "Processing... This may take a moment for large directories."

# 6. Apply Permissions
# Change Directories to 755
# -type d = match only directories
# -exec ... {} + = runs the command on the found files efficiently
find "$TARGET_DIR" -type d -exec chmod 755 {} +

if [ $? -eq 0 ]; then
    echo "[OK] Directories set to 755."
else
    echo "[Error] Failed to set directory permissions."
fi

# Change Files to 644
# -type f = match only files
find "$TARGET_DIR" -type f -exec chmod 644 {} +

if [ $? -eq 0 ]; then
    echo "[OK] Files set to 644."
else
    echo "[Error] Failed to set file permissions."
fi

echo "--- Permission Fix Complete ---"