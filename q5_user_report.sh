#!/bin/bash

# ==========================================
# USER ACCOUNT REPORT SCRIPT (FULL MARKS)
# ==========================================

echo "====================================="
echo "        USER ACCOUNT REPORT          "
echo "====================================="

# ------------------------------------------
# 1️⃣ USER STATISTICS
# ------------------------------------------

TOTAL_USERS=$(wc -l < /etc/passwd)
SYSTEM_USERS=$(awk -F: '$3 < 1000 {count++} END{print count}' /etc/passwd)
REGULAR_USERS=$(awk -F: '$3 >= 1000 {count++} END{print count}' /etc/passwd)
LOGGED_IN=$(who | awk '{print $1}' | sort -u | wc -l)

echo ""
echo "=== USER STATISTICS ==="
echo "Total Users: $TOTAL_USERS"
echo "System Users (UID < 1000): $SYSTEM_USERS"
echo "Regular Users (UID >= 1000): $REGULAR_USERS"
echo "Currently Logged In: $LOGGED_IN"

# ------------------------------------------
# 2️⃣ USER DETAILS TABLE
# ------------------------------------------

echo ""
echo "=== REGULAR USER DETAILS ==="

printf "%-15s %-6s %-20s %-18s %-25s\n" \
"Username" "UID" "Home Directory" "Shell" "Last Login"

echo "--------------------------------------------------------------------------------------------"

awk -F: '$3 >= 1000 {print $1":"$3":"$6":"$7}' /etc/passwd |
while IFS=":" read user uid home shell
do
    LAST_LOGIN=$(lastlog -u "$user" 2>/dev/null | awk 'NR==2')

    if echo "$LAST_LOGIN" | grep -q "Never logged"; then
        LAST_LOGIN="Never Logged In"
    else
        LAST_LOGIN=$(echo "$LAST_LOGIN" | cut -c43-)
    fi

    printf "%-15s %-6s %-20s %-18s %-25s\n" \
    "$user" "$uid" "$home" "$shell" "$LAST_LOGIN"
done

# ------------------------------------------
# 3️⃣ GROUP INFORMATION
# ------------------------------------------

echo ""
echo "=== GROUP INFORMATION ==="

printf "%-20s %-10s\n" "Group Name" "Members"
echo "--------------------------------------"

awk -F: '{
split($4,a,",");
count=0;
for(i in a) if(a[i]!="") count++;
printf "%-20s %-10d\n",$1,count
}' /etc/group

# ------------------------------------------
# 4️⃣ SECURITY CHECKS
# ------------------------------------------

echo ""
echo "=== SECURITY ALERTS ==="

# Root users
ROOT_USERS=$(awk -F: '$3==0 {print $1}' /etc/passwd)
ROOT_COUNT=$(echo "$ROOT_USERS" | wc -w)

echo "Users with UID 0 (root privileges): $ROOT_COUNT"
echo "$ROOT_USERS"

echo ""

# Users without passwords (requires sudo)
echo "Users without passwords:"
sudo awk -F: '($2=="!" || $2=="*" || $2=="") {print $1}' /etc/shadow 2>/dev/null

# Inactive users
echo ""
echo "Inactive Users (Never Logged In):"
lastlog | awk 'NR>1 && /Never logged/ {print $1}'

# ------------------------------------------
# BONUS 1️⃣ PASSWORD EXPIRY INFO
# ------------------------------------------

echo ""
echo "=== BONUS: PASSWORD EXPIRY INFO ==="

awk -F: '$3>=1000 {print $1}' /etc/passwd |
while read user
do
    EXPIRY=$(sudo chage -l "$user" 2>/dev/null | grep "Password expires" | cut -d: -f2)
    echo "$user -> Password Expires:$EXPIRY"
done

# ------------------------------------------
# BONUS 2️⃣ SAVE REPORT TO HTML
# ------------------------------------------

HTML_FILE="user_report.html"

{
echo "<html><body>"
echo "<h1>User Account Report</h1>"
echo "<p>Total Users: $TOTAL_USERS</p>"
echo "<p>System Users: $SYSTEM_USERS</p>"
echo "<p>Regular Users: $REGULAR_USERS</p>"
echo "<p>Currently Logged In: $LOGGED_IN</p>"
echo "<h2>Root Users</h2><pre>$ROOT_USERS</pre>"
echo "</body></html>"
} > "$HTML_FILE"

echo ""
echo "HTML report saved as: $HTML_FILE"

# ------------------------------------------
# BONUS 3️⃣ EMAIL REPORT
# ------------------------------------------

read -p "Do you want to email this report? (y/n): " EMAIL

if [ "$EMAIL" = "y" ]; then
    read -p "Enter email address: " ADDRESS
    mail -s "User Account Report" "$ADDRESS" < "$HTML_FILE" 2>/dev/null
    echo "Email sent (if mail configured)."
fi

# ------------------------------------------
# BONUS 4️⃣ GRAPH (USER TYPE GRAPH)
# ------------------------------------------

echo ""
echo "=== BONUS: USER GRAPH ==="

echo "System Users : $SYSTEM_USERS"
printf "%0.s#" $(seq 1 $SYSTEM_USERS)
echo ""

echo "Regular Users: $REGULAR_USERS"
printf "%0.s#" $(seq 1 $REGULAR_USERS)
echo ""

echo ""
echo "========== REPORT COMPLETED =========="
