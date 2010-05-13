package Lib;

use strict;
use warnings;

sub solve_simultaneous {
	my ($find, @rows) = @_;
	my $vars = $#{$rows[0]};
	my @used;

	# Do elimination.
	row: for my $rowno (0..$#rows) {
		# Find first nonzero entry.
		my $i = 0;
		while ($rows[$rowno][$i] == 0) {
			$i++;
			next row if $i > $vars; # zero row
		}
		$used[$rowno] = $i;

		# Make the co-efficient equal to 1.
		$find->[$rowno] /= $rows[$rowno][$i];
		$rows[$rowno] = multiply_vec($rows[$rowno], 1 / $rows[$rowno][$i]);

		# Eliminate column from all other rows.
		for my $elim_rowno (0..$rowno - 1,$rowno + 1..$#rows) {
			if (abs($rows[$elim_rowno][$i]) > 10**-14) {
				$find->[$elim_rowno] -= $rows[$elim_rowno][$i]*$find->[$rowno];
				my $temp = multiply_vec($rows[$rowno], $rows[$elim_rowno][$i]);
				$rows[$elim_rowno] = subtract_vec($rows[$elim_rowno], $temp);
				$rows[$elim_rowno][$i] = 0;
			} else {
				$rows[$elim_rowno][$i] = 0;
			}
		}
	}

	my $solution = [ (0) x ($vars+1) ];

	row: for my $rowno (0..$#rows) {
		# Find first nonzero entry.
		my $i = $used[$rowno];
		if (!defined $i) {
			next row if $find->[$rowno] == 0; # zero row
			print "ERR: $find->[$rowno]\n";
			return;
		}

		# Set sol. If it's x+y=1 or something, use y=0.
		$solution->[$i] = $find->[$i];
	}

	return $solution;
}

sub multiply_vec {
	my ($vec, $c) = @_;
	return [ map { $_ * $c } @$vec ];
}

sub subtract_vec {
	my ($vec1, $vec2) = @_;
	return [ map { $vec1->[$_] - $vec2->[$_] } 0..$#$vec1 ];
}

1;
