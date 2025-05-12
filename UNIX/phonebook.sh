#!/bin/bash

# Author: Fouad Hammad
# Assignment: Junk script
# Purpose: Manage a simple phonebook that can be stored and maintained
#

PHONEBOOK="phonebook.dat"
TEMPFILE="phonebook.dat.tmp"

# Function to validate phone number format
valid_phone_num() {
    if [[ ! $1 =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]; then
        echo "Phone number not of form ###-###-####, where # is a number."
        exit 1
    fi
}

# Function to check if an entry exists
entry_exists() {
    grep -q "^$1 $2 " "$PHONEBOOK"
}

case "$1" in
    -i) # Insert a new record
        if [ $# -lt 4 ]; then
            echo "usage: phonebook.sh -i <last name> <first name> <phone number> <address>"
            exit 1
        fi
        LAST_NAME=$2
        FIRST_NAME=$3
        PHONE_NUMBER=$4
        shift 4
        ADDRESS="$@"
        valid_phone_num "$PHONE_NUMBER"
        if entry_exists "$LAST_NAME" "$FIRST_NAME"; then
            echo "Entry with \"$LAST_NAME $FIRST_NAME\" name already exists."
            exit 1
        fi
        echo "$LAST_NAME $FIRST_NAME $PHONE_NUMBER $ADDRESS" >> "$PHONEBOOK"
        sort -k1,1 -k2,2 "$PHONEBOOK" -o "$PHONEBOOK"
        ;;
    -d) # Delete the record
        if [ $# -ne 3 ]; then
            echo "usage: phonebook.sh -d <last name> <first name>"
            exit 1
        fi
        LAST_NAME=$2
        FIRST_NAME=$3
        if ! entry_exists "$LAST_NAME" "$FIRST_NAME"; then
            echo "Entry with \"$LAST_NAME $FIRST_NAME\" name does not exist."
            exit 1
        fi

        # grep and mv is used to delete any of the entries stored TEMPFILE and PHONEBOOK
        grep -v "^$LAST_NAME $FIRST_NAME " "$PHONEBOOK" > "$TEMPFILE" && mv "$TEMPFILE" "$PHONEBOOK"
        ;;
    -m) # Modify an existing entry
        if [ $# -lt 4 ]; then
            echo "usage: phonebook.sh -m <last name> <first name> <address>"
            exit 1
        fi
        LAST_NAME=$2
        FIRST_NAME=$3
        shift 3
        ADDRESS="$@"
        if ! entry_exists "$LAST_NAME" "$FIRST_NAME"; then
            echo "Entry with \"$LAST_NAME $FIRST_NAME\" name does not exist."
            exit 1
        fi

        # awk is used to scan for any changes that can be used to modify without changing all other entries
        awk -v lname="$LAST_NAME" -v fname="$FIRST_NAME" -v address="$ADDRESS" \
            '{ if ($1 == lname && $2 == fname) print $1, $2, $3, address; else print $0 }' "$PHONEBOOK" > "$TEMPFILE"
        
        # mv is then used to modify the file itself directly
        mv "$TEMPFILE" "$PHONEBOOK"
        ;;
    -p) # Print matching records
        if [ $# -ne 2 ]; then
            echo "usage: phonebook.sh -p \"<pattern>\""
            exit 1
        fi
        PATTERN=$2
        MATCHES=$(grep "$PATTERN" "$PHONEBOOK")
        if [ -z "$MATCHES" ]; then
            echo "No entries matched the $PATTERN pattern."
            exit 1
        fi
        echo "$MATCHES" | awk '{ printf "%-15s  %-15s  %-12s  %s\n", $1, $2, $3, substr($0, index($0,$4)) }'
        ;;
    *) # Invalid command
        echo "Need to specify -i, -d, -m, or -p as the first argument."
        exit 1
        ;;
esac
