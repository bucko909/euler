# We first build a cache of the entire divisor function in reverse, by picking
# a factor and adding it to the divisor sum of all multiples, rather than
# finding factors and adding them (or using the prime factor method).
# It remains to find chains.
my $target = 1000000;
my @divisor_sum = ((1) x ($target + 1));
for my $f (2..int($target/2)) {
	for my $m (2..int($target/$f)) {
		$divisor_sum[$f*$m] += $f;
	}
}
my @done = (1);
my $chainmax = 0;
my $chainmaxmin = 0;
for(my $i=2; $i <= $target; $i++) {
	my $current = $i;
	my @inchain;
	while(!defined $done[$current] && $current <= $target) {
		$done[$current] = -1;
		push @inchain, $current;
		$sum_divisors = $divisor_sum[$current];
		$current = $sum_divisors;
	}
	my $inchain = 0;
	my $chainmin = $target + 1;
	my $chainlength = $done[$current] == 1 ? 0 : @inchain;
	$current = 0 if $chainlength == 0; # We hit another chain
	for(@inchain) {
		if ($_ == $current) {
			$inchain = 1;
			$chainmin = $_;
		} elsif ($inchain) {
			$chainmin = $_ if $_ < $chainmin;
		} else {
			$chainlength--;
		}
		$done[$_] = 1;
	}
	if ($chainlength > $chainmax) {
		$chainmax = $chainlength;
		$chainmaxmin = $chainmin;
	}
}
print "$chainmaxmin\n";
