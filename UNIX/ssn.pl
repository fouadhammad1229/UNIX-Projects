#!/usr/bin/perl -w


use strict;

my %ssn_map;
my $prev_ssn;

# Author: Fouad Hammad
# Assignment: Social Security Number List
# Purpose: Creates a list of social security numbers in standard output.
#



# NOTE: $_ is the default variable. Can be used to store variables
#
# NOTE2: chomp: removes character/
#
# Note 3: % : hash
#         $ : key


# Empty Variable
if (-t STDIN && @ARGV == 0) {
	print "Usage: ssn.pl <filename>\n";
	exit 1;
}


# Input cases
while (<>) {
	chomp;
	if (!defined $prev_ssn) {
		# SSN num
		if (/^\d{3}-\d{2}-\d{4}$/) {
			if (exists $ssn_map{$_}) {
				 print "$_ already exists for $ssn_map{$_}.\n";
         exit 1;
			}
			$prev_ssn = $_; # Open to future storing
		} else {
				print "Invalid format: $_\n";
      	exit 1;
		}
	} else {
		# Name Expectation
		if (/^\s*$/) {
			print "Expecting a name after social security number $prev_ssn.\n";
      exit 1;
		}
		# stores the current line in the %ssn_map
		$ssn_map{$prev_ssn} = $_;
		$prev_ssn = undef; # Undefined value for empty SSN which is essientially a reset
	}
}


# Corrections for input

if (defined $prev_ssn) {
	print "Expecting a name after social security number $prev_ssn.\n";
	exit 1;
}

# Prints ssn list to standard output

foreach my $ssn (sort keys %ssn_map) {
	print "$ssn: $ssn_map{$ssn}\n";
}
