#!/usr/bin/perl -w
#

# Author: Fouad Hammad
# Assigment: Printing the Head of the Input with Line Numbers
# Purpose: Reads the lines in standard input and outputs the first ten lines onto standard output

use strict;


my $line_num = 0;

while (my $line = <STDIN>) {
	chomp $line; # Remove newline char
	$line_num++;
	print "$line_num: $line\n";
	last if $line_num == 10; # Stops after 10 lines
}

exit 0;
