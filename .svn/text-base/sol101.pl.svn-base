# Generate a difference table and fit to it.
use strict;
use warnings;
my $tofit = [ 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1 ];
my $vals = [ map { poly_eval($_, $tofit) } (1..12) ];

my $sum = 0;
for (0..$#$tofit) {
	my $poly = diff_fit($vals, $_);
	for(1..@$tofit+1) {
		my $result = poly_eval($_, $poly);
		if ($result != $vals->[$_-1]) {
			$sum += $result;
			last;
		}
	}
}
print "$sum\n";

sub diff_fit {
	my ($vals, $degree) = @_;

	# p[i] = [1, i, i^2, i^3, ...]
	my @polies;
	for my $n (0..$degree) {
		$polies[$n] = [ map { ($n+1) ** $_ } (0..$degree) ];
	}

	# difftable[i] is the coefficients on the ith row of the polynomial
	# difference table (shifted so that the first nonzero term is the first
	# entry).
	# valtable[i] is the same but for the value difference table.
	my @difftable = (\@polies);
	my @valtable = ($vals);
	for my $row (1..$degree) {
		for my $entry (0..$degree-$row) {
			$difftable[$row][$entry][$_] =
				$difftable[$row-1][$entry+1][$_]-$difftable[$row-1][$entry][$_] for(0..$degree);
			$valtable[$row][$entry] =
				$valtable[$row-1][$entry+1] - $valtable[$row-1][$entry];
		}
	}

	# We only need the first entries, so pull them out.
	my @diff_coef = map { $difftable[$_][0] } (0..$degree);
	my @diff_vals = map { $valtable[$_][0] } (0..$degree);
	my @poly;

	# Solve the silmultaneous equations, starting from the last row. They are
	# always directly solvable so nothing complex is needed.
	for(0..$degree) {
		my $power = $degree - $_;
		my $sum = $diff_vals[$power];
		for($power+1..$degree) {
			$sum -= $diff_coef[$power][$_] * $poly[$_];
		}
		$poly[$power] = $sum / $diff_coef[$power][$power];
	}
	return \@poly;
}

# Evaluate a polynomial.
sub poly_eval {
	my ($val, $polycoef) = @_;
	my $sum = 0;
	for(0..$#$polycoef) {
		$sum += $polycoef->[$_] * $val ** $_;
	}
	return $sum;
}
