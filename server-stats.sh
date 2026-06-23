#!/bin/bash

#server-stats.sh
#Analyse basic server performance statistics

separator() {
  echo "--------------------------------------------------"
}

echo"============================================"
echo "Server Performance Statistics - $(date)"
echo "============================================"


# OS INFORMATION

separator
echo "OS Version:"
if [ -f /etc/os-release ]; then
    grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"'
else
    uname -a
fi


# Uptime & Load Average

separator
echo "Uptime & Load Average:"
uptime


# CPU Usage

separator
echo "Total CPU Usage:"
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{for(i=1;i<=NF;i++){if($i ~ /id/){print $i}}}' | awk '{print $1}')
if [ -z "$cpu_idle" ]; then
    #fallback using /proc/stat
    cpu_line1=$(grep '^cpu ' /proc/stat)
    sleep 1
    cpu_line2=$(grep '^cpu ' /proc/stat)

    read -r _ u1 n1 s1 i1 w1 irq1 sirq1 st1 <<< "$cpu_line1"
    read -r _ u2 n2 s2 i2 w2 irq2 sirq2 st2 <<< "$cpu_line2"

    prev_idle=$((i1 + w1))
    idle=$((i2 + w2))
    prev_non_idle=$((u1 + n1 + s1 + irq1 + sirq1 + st1))
    non_idle=$((u2 + n2 + s2 + irq2 + sirq2 + st2))

    prev_total=$((prev_idle + prev_non_idle))
    total=$((idle + non_idle))

    totalId=$((total - prev_total))
    idled=$((idle - prev_idle))

    cpu_usage=$(awk -v td="$totalId" -v id="$idled" 'BEGIN {printf "%.2f", (td - id) / td * 100}')
else
    cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN {printf "%.2f", 100 - idle}')
fi
echo "CPU Usage: ${cpu_usage}%"


#Memory Usage

separator
echo "Memory Usage:"
free -m | awk '
NR==2 {
    total=$2
    used=$3
    free=$4
    shared=$5
    buff_cache=$6
    available=$7
    printf "Total Memory: %s MB\nUsed Memory: %s MB\nFree Memory: %s MB\nShared Memory: %s MB\nBuffer/Cache: %s MB\nAvailable Memory: %s MB\n", total, used, free, shared, buff_cache, available
}'


# Disk Usage

separator
echo "Disk Usage:"
df -h --total 2>/dev/null | grep '^total' | awk '{printf "Total: %s | Used: %s (%s) | Free: %s\n", $2, $3, $5, $4}'

if [ $? -ne 0 ] || [ -z "$(df -h --total 2>/dev/null | grep '^total')" ]; then
    df -h | grep -E '^/dev/'
fi


# Top 5 processes by cpu usage

separator
echo "Top 5 Processes by CPU Usage:"
PS -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6


# Top 5 processes by Memory Usage

separator
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6


# Logged in Users

separator
echo "Logged in Users:"
who


# Failed login attempts

separator
echo "Failed login Attempts:"
if [ -f /var/log/auth.log ]; then
    grep "Failed password" /var/log/auth.log | tail -n 10
elif [ -f /var/log/secure ]; then
    grep "Failed password" /var/log/secure | tail -n 10
else
    echo "No authentication log file found."
fi


separator
echo "End of Server Performance Statistics"
