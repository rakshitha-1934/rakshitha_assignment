#!/bin/bash

while true
do
echo "======== FILE & DIRECTORY MANAGER ========"
echo "1. List files"
echo "2. Create directory"
echo "3. Create file"
echo "4. Delete file"
echo "5. Rename file"
echo "6. Search file"
echo "7. Count files & directories"
echo "8. View permissions"
echo "9. Copy file"
echo "10. Exit"

read -p "Enter choice: " choice

case $choice in

1) ls -lh ;;

2) read -p "Enter directory name: " dir
   mkdir -p "$dir"
   echo "Directory created."
   ;;

3) read -p "Enter file name: " file
   touch "$file"
   echo "File created."
   ;;

4) read -p "Enter file to delete: " file
   if [ -f "$file" ]; then
       read -p "Are you sure? (y/n): " confirm
       [ "$confirm" = "y" ] && rm "$file"
   else
       echo "File not found."
   fi
   ;;

5) read -p "Old name: " old
   read -p "New name: " new
   [ -e "$old" ] && mv "$old" "$new"
   ;;

6) read -p "Enter search pattern: " pattern
   find . -name "*$pattern*"
   ;;

7) echo "Files: $(find . -type f | wc -l)"
   echo "Directories: $(find . -type d | wc -l)"
   ;;

8) ls -l ;;

9) read -p "Source file: " src
   read -p "Destination: " dest
   cp "$src" "$dest"
   ;;

10) exit ;;

*) echo "Invalid option" ;;

esac
done
