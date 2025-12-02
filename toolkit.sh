#!/bin/bash

# ==========================================
# Script: Main Toolkit Menu
# Description: Central dashboard to launch all automation modules.
# ==========================================

# 1. Source Configuration
# We check if config exists to display the project name
if [ -f "CONFIG.conf" ]; then
    source CONFIG.conf
else
    PROJECT_NAME="SysAdmin Toolkit"
fi

# 2. Check for Root (Most scripts need it)
if [ "$EUID" -ne 0 ]; then
    echo "Warning: It is recommended to run this toolkit as root (sudo)."
    read -p "Press Enter to continue anyway..."
fi

# 3. Define Helper Functions

# Function to pause and wait for user input before clearing screen
pause_and_continue() {
    echo ""
    read -p "Press [Enter] to return to the main menu..."
}

# Function to draw the header
show_header() {
    clear
    echo "==================================================="
    echo "   $PROJECT_NAME - Main Menu"
    echo "==================================================="
    echo "Hostname: $(hostname)"
    echo "User:     $USER"
    echo "Date:     $(date '+%Y-%m-%d %H:%M:%S')"
    echo "==================================================="
}

# 4. Main Logic Loop
while true; do
    show_header
    
    #echo "  [ User Management ]"
    echo "  1. Add New User"
    echo "  2. Delete User"
    
    #echo "  [ File & System Ops ]"
    echo "  3. Fix File Permissions"
   
    #echo "  [ Logs & Monitoring ]"
    echo "  4. Analyze Logs (Security)"
    echo "  5. System Health Check"
    echo "  6. Network & Port Scan"
    echo "  7. Update System Packages"

    echo "  0. Exit"
    echo "==================================================="
    read -p "  Enter your choice [0-7]: " CHOICE

    case $CHOICE in
        1)
            ./scripts/user_add.sh
            pause_and_continue
            ;;
        2)
            ./scripts/user_del.sh
            pause_and_continue
            ;;
        3)
            ./scripts/perm_fix.sh
            pause_and_continue
            ;;
        4)
            ./scripts/log_analyze.sh
            pause_and_continue
            ;;
        5)
            ./scripts/health_check.sh
            pause_and_continue
            ;;
        6)
            ./scripts/net_scan.sh
            pause_and_continue
            ;;
        7)
            ./scripts/sys_update.sh
            pause_and_continue
            ;;

        0)
            echo "Exiting... Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 1
            ;;
    esac
done