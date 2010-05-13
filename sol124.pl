# Use a customised seive. Compute all the primes up to the root of n, then
# build a radical array using them.
my $n = 100000;
my $find = 10000;
my $max = int(($n+2)/2);
my @seive = ((1) x $max);
my @rad = (0, (1, 2) x ($max-1)); # Hardcode factors of 2
my $max_prime = int((sqrt($n)+1)/2);

# This loop does the seive for odd primes.
for my $primen (2..$max) {
	next unless $seive[$primen];
	my $prime = 2*$primen-1;
	if ($primen <= $max_prime) {
		for(my $num=$prime+$primen; $num <= $max; $num += $prime) {
			$seive[$num] = 0;
		}
	}
	for(my $num=$prime; $num <= $n; $num += $prime) {
		$rad[$num] *= $prime;
	}
}
my @arr = sort { $rad[$a] <=> $rad[$b] } (0..$n);
print "$arr[$find]\n";
