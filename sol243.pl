# R(p_1^i_1p_2^i_2...) = phi(n)/(n-1) = n/(n-1)* prod_i(1-1/p_i)
# So the best values are multiples of the first k primes.
# The fraction given is very close to one multiple of primes, so only a small
# tweak is needed.
# In fact, the local minima are given by:
# p_1*p_2*...*p_{n-1}*k where 1<=k<p_n - so we just run through those.

my @primes = (3,5,7,11,13,17,19,23,29,31);
my $prod = 2;
my @used = (2);
my $best;
for my $prime (@primes) {
	my $res = 1;
	for my $p (@used) {
		$res *= 1 - 1/$p;
	}
	for my $mul (1..$prime-1) {
		if ($res*$prod*$mul/($prod*$mul-1) < 15499/94744) {
			print "".($mul*$prod)."\n";
			exit;
		}
	}
	$prod *= $prime;
	push @used, $prime;
}
