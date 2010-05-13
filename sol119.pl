# Can approach this problem from reverse. For each n and each i, calculate
# n^i, and see if its digital sum is n.

use Lib;
use strict;
use warnings;

my @results;
my $maxdigits = length 2**63;
for(my $n = 1; $n < 9 * $maxdigits; $n++) {
	for(my $i = 2; $i < 30; $i++) {
		my $exp = $n ** $i;
		last if $exp > 2**63;
		my $test = Lib::sum_digits($exp);
		if ($test == $n && $exp >= 10) {
			push @results, $exp;
		}
	}
}

@results = sort { $a <=> $b } @results;
printf("%i\n", $results[29]);
