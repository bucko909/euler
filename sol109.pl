# Just nested loops. Pick the double, then pick the other two in increasing
# order.
use strict;
use warnings;
my $count = 0;
for my $v (2..99) {
	for my $double (1..20,25) {
		my $current = $v - $double * 2;
		if ($current == 0) {
			$count++;
		}
		next if $current <= 0;
		for my $first ((map { [ $_, 1 ], [ $_, 2 ], [ $_, 3 ] } (1..20)), [25, 1], [25, 2]) {
			my ($fval, $fmul) = @$first;
			next if $current - $fval * $fmul < 0;
			my $score = $current - $fval * $fmul;
			my @v = ("X", "S", "D", "T");
			if ($score == 0) {
				$count++;
				next;
			}
			if ($score % 3 == 0 && $score <= 60) {
				my $trip = $score / 3;
				if ($trip  >  $fval || ($trip == $fval && $fmul == 3)) {
					$count++;
				}
			}
			if ($score % 2 == 0 && ($score <= 40 || $score == 50)) {
				my $doub = $score / 2;
				if ($doub  >  $fval || ($doub == $fval && $fmul >= 2)) {
					$count++;
				}
			}
			if ($score <= 20 || $score == 25) {
				if ($score >= $fval) {
					$count++;
				}
			}
		}
	}
}
print "$count\n";
