#!/bin/bash

# Ensure the script runs with a clear and readable layout
echo "========================================"
echo "          SERVER PERFORMANCE STATS      "
echo "========================================"

# 1. Stretch Goals: Basic System Info
echo -e "\n--- System Overview ---"
echo "OS Version:     $(cat /etc/os-release | grep -w "PRETTY_NAME" | cut -d= -f2 | tr -d '"')"
echo "Uptime:         $(uptime -p)"
echo "Load Average:   $(cat /proc/loadavg | awk '{print $1", "$2", "$3}')"
echo "Logged-in Users: $(who | wc -l)"

# 2. Total CPU Usage
echo -e "\n--- CPU Usage ---"
# Calculates total CPU usage by looking at idle time from 'top'
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
cpu_usage=$(echo "100 - $cpu_idle" | bc)
echo "Total CPU Usage: ${cpu_usage}%"

# 3. Total Memory Usage (Free vs Used with Percentage)
echo -e "\n--- Memory Usage ---"
free -m | awk 'NR==2{printf "Used: %s MB / Total: %s MB\nFree: %s MB\nMemory Usage: %.2f%%\n", $3, $2, $4, $3*100/$2}'

# 4. Total Disk Usage (Free vs Used with Percentage)
echo -e "\n--- Disk Usage (Root Partition) ---"
df -h / | awk 'NR==2{printf "Used: %s / Total: %s\nFree: %s\nDisk Usage: %s\n", $3, $2, $4, $5}'

# 5. Top 5 Processes by CPU Usage
echo -e "\n--- Top 5 Processes by CPU Usage ---"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

# 6. Top 5 Processes by Memory Usage
echo -e "\n--- Top 5 Processes by Memory Usage ---"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6

# 7. Stretch Goal: Failed Login Attempts
echo -e "\n--- Security ---"
if [ -f /var/log/auth.log ]; then
    failed_logins=$(grep "Failed password" /var/log/auth.log | wc -l)
    echo "Failed login attempts: $failed_logins"
elif [ -f /var/log/secure ]; then
    failed_logins=$(grep "Failed password" /var/log/secure | wc -l)
    echo "Failed login attempts: $failed_logins"
else
    echo "Failed login attempts: Log file not found (Requires sudo/root access normally)"
fi

echo -e "\n========================================"
