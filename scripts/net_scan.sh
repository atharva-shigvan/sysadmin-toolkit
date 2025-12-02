# 1. Source Configuration
source "../CONFIG.conf"

# 2. Colors for Output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# 3. Check for Root Privileges
if [ "$EUID" -ne 0 ]; then
    echo "Error: Run as root to see process names and firewall status."
    exit 1
fi

echo "--- Network Security Audit ---"
echo "Date: $(date)"

# --- Part 1: Firewall Status ---
echo "------------------------------"
echo "Checking Firewall Status..."

# Check if UFW (Uncomplicated Firewall) is active
if command -v ufw &> /dev/null; then
    UFW_STATUS=$(ufw status | grep "Status" | awk '{print $2}')
    
    if [ "$UFW_STATUS" == "active" ]; then
        echo -e "Firewall (UFW): ${GREEN}ACTIVE${NC}"
    else
        echo -e "Firewall (UFW): ${RED}INACTIVE${NC} (Warning!)"
    fi
else
    # Fallback for systems without UFW (check iptables)
    echo "UFW not found. Checking iptables chains..."
    iptables -L | grep "Chain" | head -n 3
fi

# --- Part 2: Port Audit ---
echo "------------------------------"
echo "Auditing Open Ports..."
echo "Allowed Ports (from config): ${ALLOWED_PORTS[*]}"
echo ""

# Get list of listening TCP/UDP ports
# ss -tuln: t=tcp, u=udp, l=listening, n=numeric (no DNS resolution)
# awk ... cuts out just the port number (after the last colon)
OPEN_PORTS=$(ss -tuln | awk 'NR>1 {print $5}' | awk -F: '{print $NF}' | sort -n | uniq)

echo -e "PORT\tSTATUS\t\tSERVICE"

for port in $OPEN_PORTS; do
    # Determine if the port is in the allowed list
    IS_ALLOWED=0
    for allowed in "${ALLOWED_PORTS[@]}"; do
        if [ "$port" == "$allowed" ]; then
            IS_ALLOWED=1
            break
        fi
    done
    
    # Get the service name for this port (e.g., 22 -> ssh)
    SERVICE_NAME=$(getent services $port | awk '{print $1}')
    if [ -z "$SERVICE_NAME" ]; then SERVICE_NAME="unknown"; fi

    if [ $IS_ALLOWED -eq 1 ]; then
        echo -e "${port}\t${GREEN}[OK]${NC}\t\t$SERVICE_NAME"
    else
        echo -e "${port}\t${RED}[FLAGGED]${NC}\t$SERVICE_NAME (Not in config!)"
    fi
done

echo "------------------------------"