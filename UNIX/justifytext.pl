#!/usr/bin/perl -w
#
use strict;

# Name: Fouad Hammad
# Assignment: Justify Text
# Purpose: A perl program that justifies lines in a text file through reading the standard input
# lines in a text file and then create a brand new text file with the justified lines.

# Read input file, output file, and max columns
chomp(my $input_file = <STDIN>);
chomp(my $output_file = <STDIN>);
chomp(my $max_columns = <STDIN>);

# Open input and output files
open my $in, '<', $input_file or die "Error: Cannot open input file '$input_file'\n";
open my $out, '>', $output_file or die "Error: Cannot open output file '$output_file'\n";

my @paragraph;

while (<$in>) {
	chomp;
	if (/^\s*$/) { #Indicates end of paragraph
		justify_paragraph(\@paragraph, $out, $max_columns) if @paragraph;
        	print $out "\n";
        	@paragraph = ();
	} else {
		push @paragraph, split /\s+/; # Collects words!
	}
}

justify_paragraph(\@paragraph, $out, $max_columns) if @paragraph;  # Process last paragraph

# Closes input and output files
close $in;
close $out;

# Function to justify the paragraph
sub justify_paragraph {
	my ($words_ref, $out, $max_col) = @_;
    	my @words = @$words_ref;
    	my @line;
    	my $line_length = 0;
	
	while (@words) {
		my $word = shift @words;
		if ($line_length + length($word) + @line <= $max_col) {
			push @line, $word;
			$line_length += length($word);
		} else {
			print $out format_line(\@line, $max_col) . "\n";
			@line = ($word);
			$line_length = length($word);
		}
	}
	print $out join(" ", @line) . "\n" if @line;
}

# Function to format a fully justified line
sub format_line {
	 my ($line_ref, $max_col) = @_;
	 my @line = @$line_ref;
	 return join(" ", @line) if @line == 1;

	 my $word_count = scalar @line;
	 my $spaces_needed = $max_col - length(join("", @line));
	 my @spaces = (1) x ($word_count - 1);

	 for my $i (0 .. $spaces_needed - 1) {
        	$spaces[$#spaces - ($i % ($word_count - 1))]++;  # Distribute extra spaces
	}

	my $justified = "";
	for my $i (0 .. $#spaces) {
		$justified .= $line[$i] . (" " x $spaces[$i]);
	}
	$justified .= $line[-1]; # Appends last word

	return $justified;
}
