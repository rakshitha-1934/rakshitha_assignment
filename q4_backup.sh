#!/bin/bash

echo "=== AUTOMATED BACKUP SCRIPT ==="

read -p "Enter directory to backup: " SOURCE
read -p "Enter backup destination: " DEST

if [ ! -d "$SOURCE" ]; then
    echo "Source directory does not exist."
    exit 1
fi

mkdir -p "$DEST"

echo "Backup Type:"
echo "1. Simple copy"
echo "2. Compressed archive (tar.gz)"
read -p "Enter choice (1 or 2): " choice

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
START=$(date +%s)

echo "[*] Starting backup..."
echo "[*] Source: $SOURCE"
echo "[*] Destination: $DEST"

if [ "$choice" -eq 1 ]; then
    cp -r "$SOURCE" "$DEST/backup_$TIMESTAMP"
    BACKUP_FILE="$DEST/backup_$TIMESTAMP"
else
    tar --exclude="$DEST" -czf "$DEST/backup_$TIMESTAMP.tar.gz" "$SOURCE"
    BACKUP_FILE="$DEST/backup_$TIMESTAMP.tar.gz"
fi

END=$(date +%s)
DURATION=$((END - START))

echo "Backup completed successfully!"

echo "===== Backup Details ====="
echo "File: $(basename "$BACKUP_FILE")"
echo "Location: $DEST"
du -sh "$BACKUP_FILE" | awk '{print "Size: "$1}'
echo "Time taken: $DURATION seconds"

touch "$DEST/backup.log"
echo "$(date) - Backup created: $BACKUP_FILE" >> "$DEST/backup.log"

echo "[*] Checking old backups..."

ls -t "$DEST"/backup_* 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null

echo "[*] Old backups cleaned (kept latest 5)"

echo "[*] Log updated at $DEST/backup.log"
