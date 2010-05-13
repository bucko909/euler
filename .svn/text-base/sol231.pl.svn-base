# Use a customised seive. Compute all the primes up to the root of $n and do
# the sum as we roll.
my $n = 2*10**7;
my $r = 15*10**6;
my $sum = sum_factors($n, $r, 2); # 2 isn't an odd prime, so deal with it first
my $max = int(($n+2)/2);
my @seive = ((1) x $max);
my $max_prime = int((sqrt($n)+1)/2);

# This loop does the seive for odd primes.
for my $primen (2..$max_prime) {
	next unless $seive[$primen];
	my $start = 3*$primen-1;
	my $add = 2*$primen-1;
	for(my $num=$start; $num <= $max; $num += $add) {
		$seive[$num] = 0;
	}
	$sum += sum_factors($n, $r, 2*$primen-1);
}

# For all remaining primes, compute if they fit.
# There is a possible optimisation on this loop, since for large primes,
# the remainders will change by only small amounts. It is thus possible to skip
# small blocks of primes. Particularly, once the value of the prime is above
# $r, we never need to compute $r_p. Once the prime is above $n-$r+1 we are
# guaranteed to need to add it. However, as the seive above is the slowest part
# of the code, it seems pointless.
for my $primen ($max_prime+1..$max) {
	next unless $seive[$primen];
	# Inlining this here saves rather more costly calls to sum_factors and
	# reduces runtime by a few seconds. Since we're above root n, we don't need
	# to care about prime powers any more.
	my $prime = 2 * $primen - 1;
	my $r_p = $r % $prime;
	my $nr_p = ($n-$r+1) % $prime;
	$sum += $prime if $r_p != 0 && ($r_p + $nr_p > $prime || $nr_p == 0);
}

sub sum_factors {
	my ($n, $r, $prime) = @_;
	my $sum = 0;
	my $prime_power = $prime;
	while ($prime_power < $n) {
		# Simple analysis shows that to have a factor in [n-r+1, n] which is not
		# in [1, r] we need f does not divide r, and either f divides n-r+1 or
		# the "shift" (n-r+1)%f is enough to fit an extra factor in before n.
		my $r_p = $r % $prime_power;
		my $nr_p = ($n-$r+1) % $prime_power;
		$sum += $prime if $r_p != 0 && ($r_p + $nr_p > $prime_power || $nr_p == 0);
		$prime_power *= $prime;
	}
	return $sum;
}

print "$sum\n";
