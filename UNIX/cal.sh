#!/bin/bash

# Author: Fouad Hammad
# Assignment: Cal Interface Shell Script
# Purpose: Upgrade the Calandar interface to use numbers and allows for one or two arguments.
# FOr example: You can state Jan 2025 and it will display the calandar for January 2025 and 
# vice versa.

# Array for month name conversion
MONTHS=("jan" "feb" "mar" "apr" "may" "jun" "jul" "aug" "sep" "oct" "nov" "dec")


# Get current date
CURRENT_MONTH=$(date +%m)
CURRENT_YEAR=$(date +%Y)

# Function to check if input is valid
is_number() {
        [[ "$1" =~ ^[0-9]+$ ]]
}

# Function to convert month name to a number.
month_to_num() {
        local month_low=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        for i in "${!MONTHS[@]}"; do
                if [[ "${MONTHS[$i]}" == "$month_low" ]]; then
                        echo $((i + 1))
                        return
                fi
        done
        echo 0 # if program does not match current parameters
}

# Validate arugments and call cal
if [ $# -eq 0 ]; then
        cal $CURRENT_MONTH $CURRENT_YEAR
elif [ $# -eq 1 ]; then
        if is_number "$1"; then
                if (( $1 >= 1 && $1 <= 12 )); then
                        cal $1 $CURRENT_YEAR
                elif (( $1 >= 1000 && $1 <= 9999 )); then
                        cal $1
                else
                        echo "usage: cal [[month] year]"
                        exit 1
                fi
        else
                month_num=$(month_to_num "$1")
                if [ $month_num -ne 0 ]; then
                        cal $month_num $CURRENT_YEAR
                else
                        echo "$1 is not a valid month."
                        exit 1
                fi
        fi
elif [ $# -eq 2 ]; then
    if is_number "$2" && (( $2 >= 1000 && $2 <= 9999 )); then
        if is_number "$1" && (( $1 >= 1 && $1 <= 12 )); then
            cal $1 $2
        else
            month_num=$(month_to_num "$1")
            if [ $month_num -ne 0 ]; then
                cal $month_num $2
            else
                echo "$1 is not a valid month."
                exit 1
            fi
        fi
    else
        echo "usage: cal [[month] year]"
        exit 1
    fi
  else
        echo "usage: cal [[month] year]"
        exit 1
fi
