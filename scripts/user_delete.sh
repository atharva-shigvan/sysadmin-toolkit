# 1. Source Configuration
source "$(dirname "$0")/../config.conf"

# 2. Check for Root Privileges
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

echo "--- Delete User Account ---"

# 3. Get Username Input
read -p "Enter username to delete: " USER_NAME

# 4. Input Validation
if [ -z "$USER_NAME" ]; then
    echo "Error: Username cannot be empty."
    exit 1
fi

# Check if user actually exists
if ! id "$USER_NAME" &>/dev/null; then
    echo "Error: User '$USER_NAME' does not exist."
    exit 1
fi

# 5. Whitelist Protection Check
# We loop through the WHITELISTED_USERS array from config.conf
for safe_user in "${WHITELISTED_USERS[@]}"; do
    if [ "$USER_NAME" == "$safe_user" ]; then
        echo "CRITICAL ERROR: '$USER_NAME' is a protected system user!"
        echo "Action aborted for safety."
        exit 1
    fi
done

# 6. Archive Option
read -p "Do you want to archive the user's home directory before deleting? (y/n): " ARCHIVE_OPT

if [[ "$ARCHIVE_OPT" =~ ^[Yy]$ ]]; then
    # Define archive name with timestamp
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    ARCHIVE_FILE="$BACKUP_DEST_DIR/${USER_NAME}_home_backup_$TIMESTAMP.tar.gz"
    
    echo "Archiving /home/$USER_NAME to $ARCHIVE_FILE..."
    
    # Run tar compression
    tar -czf "$ARCHIVE_FILE" "/home/$USER_NAME" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "[Success] Archive created."
    else
        echo "[Warning] Failed to create archive (Directory might not exist)."
    fi
fi

# 7. Delete User
# -r removes the home directory and mail spool
echo "Deleting user '$USER_NAME'..."
userdel -r "$USER_NAME"

if [ $? -eq 0 ]; then
    echo "--- Success: User '$USER_NAME' has been deleted. ---"
else
    echo "Error: Failed to delete user. Check if they are currently logged in."
fi