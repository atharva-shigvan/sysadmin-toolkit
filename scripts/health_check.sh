# 1. Source Configuration
source "../CONFIG.conf"

# 2. Define Colors for Output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "--- System Health Status ---"
echo "Date: $(date)"
echo "----------------------------"

# --- Part 1: CPU Usage ---
# We get the 'idle' percentage from top and subtract it from 100 to get 'usage'.
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print $1}')
CPU_USAGE=$(awk -v idle="$CPU_IDLE" 'BEGIN {print 100 - idle}')

# Compare with threshold using awk (Bash if doesn't handle floats well)
CPU_STATUS=$(awk -v usage="$CPU_USAGE" -v limit="$CPU_ALERT_THRESHOLD" 'BEGIN {if(usage > limit) print "ALERT"; else print "OK"}')

if [ "$CPU_STATUS" == "ALERT" ]; then
    echo -e "CPU Load: ${RED}${CPU_USAGE}% (High Load)${NC}"
else
    echo -e "CPU Load: ${GREEN}${CPU_USAGE}% (Normal)${NC}"
fi

# --- Part 2: Memory Usage ---
# Uses free -m to get values in Megabytes
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_PERCENT=$(awk -v used="$MEM_USED" -v total="$MEM_TOTAL" 'BEGIN {printf "%.1f", (used/total)*100}')

MEM_STATUS=$(awk -v usage="$MEM_PERCENT" -v limit="$MEM_ALERT_THRESHOLD" 'BEGIN {if(usage > limit) print "ALERT"; else print "OK"}')

if [ "$MEM_STATUS" == "ALERT" ]; then
    echo -e "Memory:   ${RED}${MEM_PERCENT}% (${MEM_USED}MB / ${MEM_TOTAL}MB)${NC}"
else
    echo -e "Memory:   ${GREEN}${MEM_PERCENT}% (${MEM_USED}MB / ${MEM_TOTAL}MB)${NC}"
fi

# --- Part 3: Disk Usage ---
# Checks the usage of the root partition "/"
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt "$DISK_ALERT_THRESHOLD" ]; then
    echo -e "Disk (/): ${RED}${DISK_USAGE}% (Running out of space!)${NC}"
else
    echo -e "Disk (/): ${GREEN}${DISK_USAGE}% (Space OK)${NC}"
fi

echo "----------------------------"
