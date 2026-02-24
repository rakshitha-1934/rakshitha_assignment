#!/bin/bash


CYAN="\e[36m"
RESET="\e[0m"

USERNAME=$(whoami)
HOSTNAME=$(hostname)
DATETIME=$(date "+%Y-%m-%d %H:%M:%S")
OS=$(uname -s)
CURRENT_DIR=$(pwd)
HOME_DIR=$HOME
USERS_ONLINE=$(who | wc -l)
UPTIME=$(uptime -p)

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
MEM_USAGE=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

echo -e "${CYAN}=============================================="
echo -e "||     SYSTEM INFORMATION DISPLAY          ||"
echo -e "=============================================="
printf "|| Username     : %-22s ||\n" "$USERNAME"
printf "|| Hostname     : %-22s ||\n" "$HOSTNAME"
printf "|| Date & Time  : %-22s ||\n" "$DATETIME"
printf "|| OS           : %-22s ||\n" "$OS"
printf "|| Current Dir  : %-22s ||\n" "$CURRENT_DIR"
printf "|| Home Dir     : %-22s ||\n" "$HOME_DIR"
printf "|| Users Online : %-22s ||\n" "$USERS_ONLINE"
printf "|| Uptime       : %-22s ||\n" "$UPTIME"
printf "|| Disk Usage   : %-22s ||\n" "$DISK_USAGE"
printf "|| Memory Usage : %-22s ||\n" "$MEM_USAGE"
echo -e "==============================================${RESET}"
