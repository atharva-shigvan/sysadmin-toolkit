#Check if running as root
#We need root to create directories in /var/ and set permissions
if [ "$EUID" -ne 0 ]; then 
    echo "Error: Please run this script as root (sudo ./install.sh)"
    exit 1
fi

echo "--- Starting Installation ---"

#Source the configuration file
#We need to read variables like BACKUP_DEST_DIR to know what to create
if [ -f "config.conf" ]; then
    source config.conf
    echo "[OK] Configuration file found."
else
    echo "[Error] config.conf not found! Please ensure it is in the same directory."
    exit 1
fi

#Create Necessary Directories
echo "--- Setting up Directories ---"

#Create Backup Destination
if [ ! -d "$BACKUP_DEST_DIR" ]; then
    mkdir -p "$BACKUP_DEST_DIR"
    echo "[Created] Backup Directory: $BACKUP_DEST_DIR"
else
    echo "[Exists] Backup Directory: $BACKUP_DEST_DIR"
fi

#Create Log Archive Directory
if [ ! -d "$LOG_ARCHIVE_DIR" ]; then
    mkdir -p "$LOG_ARCHIVE_DIR"
    echo "[Created] Log Archive Directory: $LOG_ARCHIVE_DIR"
else
    echo "[Exists] Log Archive Directory: $LOG_ARCHIVE_DIR"
fi

#Set Permissions
echo "--- Setting Executable Permissions ---"

#Make the main menu executable
if [ -f "toolkit.sh" ]; then
    chmod +x toolkit.sh
    echo "[OK] Made toolkit.sh executable."
fi

#Make all scripts in the scripts/ folder executable
if [ -d "scripts" ]; then
    chmod +x scripts/*.sh
    echo "[OK] Made all scripts in 'scripts/' executable."
else
    echo "[Warning] 'scripts' folder not found. Please check your download."
fi

#Dependency Check
echo "--- Checking Dependencies ---"
DEPENDENCIES=("tar" "gzip" "grep" "awk" "sed" "ss")

for cmd in "${DEPENDENCIES[@]}"; do
    if ! command -v $cmd &> /dev/null; then
        echo "[Warning] Command '$cmd' not found. Some scripts may not work."
    else
        echo "[OK] Found: $cmd"
    fi
done

echo "--- Installation Complete! ---"
echo "You can now run the tool using: sudo ./toolkit.sh"