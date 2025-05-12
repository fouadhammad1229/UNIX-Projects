#!/bin/bash

# Author: Fouad Hammad
# Assignment: Junk script
# Purpose: Moves a file or directory to a .junk directory to save later.
# Essientially a recycling bin equivalent

# Check if there is one arguement
if [ "$#" -ne 1 ]; then
    echo "usage: junk.sh <filename>"
    exit 1
fi

# Definitions
FILE="$1"
JUNK_DIR="$HOME/.junk"

# Check if the file exists in current directory
if [ ! -e "$FILE" ]; then
    echo "The $FILE file has to exist to be junked!"
    exit 1
fi

# Check if the file is able to be written
if [ ! -w "$FILE" ]; then
    echo "The $FILE file has to be writable in order for it to be junkable."
    exit 1
fi

# Handles if the input is a directory
if [ -d "$FILE" ]; then
    echo "$FILE is a directory."
    read -p "Type 'y' if you wish to junk the entire directory: " RESPONSE
    if [ "$RESPONSE" != "y" ]; then
        echo "ABORTING."
        exit 1
    fi

    # Check if directory already exists in .junk
    if [ -d "$JUNK_DIR/$FILE" ]; then
        echo "Cannot junk $FILE because it has already been junked."
        exit 1
    fi

else
    # If input is a file
    if [ -e "$JUNK_DIR/$FILE" ]; then
        echo "$FILE has already been junked."
        read -p "Type 'y' if you wish to overwrite a previously junked $FILE file: " RESPONSE
        if [ "$RESPONSE" != "y" ]; then
            echo "ABORTING"
            exit 1
        fi
    fi
fi

# Create a .junk dir if DNE
if [ ! -d "$JUNK_DIR" ]; then
    mkdir "$JUNK_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create $JUNK_DIR."
        exit 1
    fi
fi

# Move the file or directory to junk directory
mv "$FILE" "$JUNK_DIR/"
if [ $? -eq 0 ]; then
    echo "$FILE has been sucessfully junked!"
    exit 0
else
    echo "Failed to junk $FILE." # :(
    exit 1
fi
