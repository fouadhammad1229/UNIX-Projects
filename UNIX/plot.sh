#!/bin/bash

# Name: Fouad Hammad
# Assignment: Plot Shell Script
# Purpose: A shell script capable of plotting integer values into a histogram via gnuplot.
#
# Also allows us to use heads, tails and ps2pdf

# Argument checker
if [ "$#" -ne 2 ]; then
        echo "Usage: plot.sh filename fieldname"
        exit 1
fi

filename="$1"
fieldname="$2"

tmp_data="tmp1.dat"
tmp_sorted="tmp2.dat"
tmp_freq="tmp3.dat"
tmp_plot="plot1.p"

# Check if file exists
if [ ! -f "$filename" ]; then
        echo "File $filename not found."
        exit 1
fi


# Extract the header and find the column index
header=$(head -n 1 "$filename")
index=0
found=0
for field in $header; do
        if [ "$field" == "$fieldname" ]; then
                found=1
                break
        fi
        index=$((index + 1))
done

if [ "$found" -eq 0 ]; then
        echo "Field $fieldname not found in the first line of the file $filename."
        exit 1
fi

# Extract the column values (skip the header)
cut -d' ' -f$((index + 1)) "$filename" | tail -n +2 | sort -n > "$tmp_sorted"

# Get first and last values
lowx=$(head -n 1 "$tmp_sorted")
highx=$(tail -n 1 "$tmp_sorted")

# Compute the frequency and get the highest freq
uniq -c "$tmp_sorted" | awk '{print $2, $1}' > "$tmp_freq"
highy=$(awk '{print $2}' "$tmp_freq" | sort -nr | head -n 1)


# Copy and modify the plot script
#
cp /home/faculty/whalley/cop4342exec/plot.p "$tmp_plot"

sed -i "s/LOWX/$lowx/" "$tmp_plot"
sed -i "s/HIGHX/$highx/" "$tmp_plot"
sed -i "s/HIGHY/$highy/" "$tmp_plot"
sed -i "s/FILE/$tmp_freq/" "$tmp_plot"


# RUN GNUPLOT and generate pdf via ps2pdf
gnuplot "$tmp_plot"
ps2pdf graph.ps graph.pdf # Converts the .ps file to pdf

# Cleanup time
rm -f "$tmp_data" "$tmp_sorted" "$tmp_freq" "$tmp_plot" graph.ps

echo "$fieldname in the $filename file was successfully plotted"
