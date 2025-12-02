# 1. Source Configuration
source "../CONFIG.conf"

# 2. Check for Root Privileges
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root to update the system."
    exit 1
fi

echo "--- System Update & Patching ---"
echo "Date: $(date)"

# 3. Detect Package Manager and Run Update
if command -v apt &> /dev/null; then
    # --- Debian / Ubuntu ---
    echo "[Detected] APT Package Manager (Debian/Ubuntu)"
    
    echo "1. Updating Package Lists..."
    apt update -y
    
    echo "2. Upgrading Installed Packages..."
    # -y automatically answers "yes" to prompts
    apt upgrade -y
    
    echo "3. Cleaning up unused dependencies..."
    apt autoremove -y
    apt autoclean -y

else
    echo "[Error] No supported package manager found (apt)."
    exit 1
fi

echo "--- Update Complete ---"

# 4. Check if Reboot is Required (Ubuntu/Debian specific)
if [ -f /var/run/reboot-required ]; then
    echo ""
    echo -e "\033[0;31m[WARNING] A system reboot is required to complete updates (kernel changed).\033[0m"
fi