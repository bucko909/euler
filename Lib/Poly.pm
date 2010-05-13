package Lib;

use strict;
use warnings;

sub poly_divide {
	my ($poly1, $poly2) = @_;
	my @quot;
	my @remainder = @$poly1;
	while(@remainder >= @$poly2) {
		my $factor = $remainder[$#remainder] / $poly2->[$#$poly2];
		unshift @quot, $factor;
		my $mul = @remainder - @$poly2;
		for my $pow (0..$#$poly2-1) {
			$remainder[$mul + $pow] -= $factor * $poly2->[$pow];
		}
		pop @remainder; # zeroed that bit.
	}
	return wantarray ? (\@quot, \@remainder) : \@quot;
}

sub poly_eval {
	my ($poly, $val) = @_;
	my $ret = 0;
	my $current = 1;
	for(@$poly) {
		$ret += $current * $_;
		$current *= $val;
	}
	return $ret;
}

1;
