#!/bin/bash
# 1. Source Configuration (Go up one level to find config.conf)
source "$(dirname "$0")/../CONFIG.conf"

# 2. Check for Root Privileges
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

echo "--- Create New User Account ---"

# 3. Get Username Input
read -p "Enter new username: " USER_NAME

# Check if input is empty
if [ -z "$USER_NAME" ]; then
    echo "Error: Username cannot be empty."
    exit 1
fi

# 4. Check if User Already Exists
if id "$USER_NAME" &>/dev/null; then
    echo "Error: User '$USER_NAME' already exists."
    exit 1
fi

# 5. Create the User
# -m creates the home directory
# -s sets the default shell to bash
useradd -m -s /bin/bash "$USER_NAME"

# Check if useradd command succeeded
if [ $? -eq 0 ]; then
    echo "User '$USER_NAME' created successfully."
else
    echo "Error: Failed to create user."
    exit 1
fi

# 6. Set Password
echo "Please enter a password for $USER_NAME."
passwd "$USER_NAME"

# Check if password setting succeeded
if [ $? -eq 0 ]; then
    echo "--- Success: Account for '$USER_NAME' is ready. ---"
else
    echo "Warning: User created, but password setup failed."
fi