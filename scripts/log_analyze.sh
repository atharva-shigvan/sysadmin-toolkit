# 1. Source Configuration
source "$(dirname "$0")/../config.conf"

# 2. Check for Root Privileges
# Reading /var/log/auth.log usually requires root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root to read system logs."
    exit 1
fi

echo "--- System Log Analysis Report ---"
DATE_TODAY=$(date "+%b %e") # E.g., "Oct  5" (matches syslog date format)
echo "Date: $(date)"
echo "----------------------------------"

# --- Part 1: Security Audit (SSH & Auth) ---
AUTH_LOG="/var/log/auth.log"

if [ -f "$AUTH_LOG" ]; then
    echo "[Security] Scanning $AUTH_LOG..."
    
    # Grep for 'Failed password', count lines with wc -l
    FAILED_COUNT=$(grep "Failed password" "$AUTH_LOG" | wc -l)
    
    echo "   -> Total Failed Login Attempts: $FAILED_COUNT"
    
    if [ "$FAILED_COUNT" -gt 0 ]; then
        echo "   -> Top 5 Attacking IP Addresses:"
        # Logic:
        # 1. Find lines with "Failed password"
        # 2. Extract specific patterns (IPs usually appear at the end or via regex)
        # 3. Sort and count unique occurrences
        grep "Failed password" "$AUTH_LOG" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | sort | uniq -c | sort -nr | head -n 5
    fi
else
    echo "[Warning] Auth log not found at $AUTH_LOG"
fi

echo "----------------------------------"

# --- Part 2: Critical System Errors ---
SYSLOG="/var/log/syslog"

if [ -f "$SYSLOG" ]; then
    echo "[System] Scanning $SYSLOG for Critical Errors..."
    
    # Search for "critical", "error", or "fatal" (case insensitive)
    ERROR_COUNT=$(grep -iE "critical|error|fatal" "$SYSLOG" | wc -l)
    
    echo "   -> Total Critical Events Found: $ERROR_COUNT"
    
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo "   -> Last 3 Critical Messages:"
        grep -iE "critical|error|fatal" "$SYSLOG" | tail -n 3
    fi
else
    echo "[Warning] Syslog not found at $SYSLOG"
fi

echo "----------------------------------"
echo "Analysis Complete."