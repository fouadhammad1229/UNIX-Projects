#!/usr/bin/perl -w

# Author: Fouad Hammad
# Assigment: Printing the Middle Lines of the input
# Purpose: Reads the lines in standard input and outputs a number of middle lines specfied by the 
# file

use strict;


my $line_num = 10;

if (@ARGV and $ARGV[0] =~ /^-(\d+)$/) {
	$line_num = $1;
	shift @ARGV; # Shifts the values in ARGV
}

# Read all input lines

my @lines = <STDIN>;
my $tot_lines = scalar @lines;

exit 0 if $tot_lines == 0; # If the file is empty, it prints nothing and cancels

# Determines the start and end indices
#
my $last_index = $#lines;
my $start_index = int(($last_index - $line_num) / 2);
my $end_index = $start_index + $line_num - 1;


# Ensures no negative numbers are utilized in start_index or end_index
#
$start_index = 0 if $start_index < 0;
$end_index = $last_index if $end_index > $last_index;


# Prints the middle lines!
#
for my $i ($start_index .. $end_index) {
	print $lines[$i];
}

exit 0;
