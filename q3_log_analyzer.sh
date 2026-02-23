#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Usage: $0 logfile"
    exit 1
fi

LOGFILE="$1"

if [ ! -f "$LOGFILE" ]; then
    echo "Error: File not found."
    exit 1
fi

if [ ! -s "$LOGFILE" ]; then
    echo "Log file is empty."
    exit 1
fi

echo "=================================="
echo "        LOG FILE ANALYSIS         "
echo "=================================="
echo "Log File: $LOGFILE"
echo ""

TOTAL=$(wc -l < "$LOGFILE")
echo "Total Entries: $TOTAL"
echo ""

echo "Unique IP Addresses:"
awk '{print $1}' "$LOGFILE" | sort | uniq
UNIQUE_COUNT=$(awk '{print $1}' "$LOGFILE" | sort | uniq | wc -l)
echo "Total Unique IPs: $UNIQUE_COUNT"
echo ""

echo "Status Code Summary:"
awk '{print $9}' "$LOGFILE" | sort | uniq -c
echo ""

echo "Most Accessed Page:"
awk '{print $7}' "$LOGFILE" | sort | uniq -c | sort -nr | head -1
echo ""

echo "Top 3 IP Addresses:"
awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -3
echo ""


echo "========== BONUS ANALYSIS =========="

FIRST_DATE=$(awk '{print $4}' "$LOGFILE" | head -1 | tr -d '[')
LAST_DATE=$(awk '{print $4}' "$LOGFILE" | tail -1 | tr -d '[')

echo "Date Range:"
echo "From: $FIRST_DATE"
echo "To  : $LAST_DATE"
echo ""

echo "Security Threat Detection (Multiple 403 errors):"
awk '$9==403 {print $1}' "$LOGFILE" | sort | uniq -c | awk '$1 > 1'
echo ""

CSV_FILE="log_report.csv"

echo "IP,Requests" > "$CSV_FILE"
awk '{print $1}' "$LOGFILE" | sort | uniq -c | awk '{print $2 "," $1}' >> "$CSV_FILE"

echo "CSV report generated: $CSV_FILE"
echo "=================================="
