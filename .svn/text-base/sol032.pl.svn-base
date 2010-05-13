# Just run through the digits checking pandigitalism. Assume the first part
# of the product is shortest and if a draw, assume it has the lowest first
# digit.

use Lib;
use strict;
use warnings;
my @pandigital_products;
my @used = (1, (0) x 9);
a: for(my $a = 1; $a < 99; $a++) {
	my @used1 = @used;
	for(split //, $a) {
		next a if $used1[$_];
		$used1[$_] = 1;
	}
	my $start = length $a == 1 ? 1234 : 123;
	my $end = length $a == 1 ? 9876 : 987;
	b: for(my $b = $start; $b <= $end; $b++) {
		last if length($a*$b) + length($a) + length($b) > 9;
		my @used2 = @used1;
		for(split //, $b.($a*$b)) {
			next b if $used2[$_];
			$used2[$_] = 1;
		}
		push @pandigital_products, $a*$b;
	}
}
my %unique = map { $_ => 1 } @pandigital_products;
print Lib::sum(keys %unique)."\n";
