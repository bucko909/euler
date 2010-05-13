# Number of fractions n/m with n<m is phi(m).
# So we just need to sum phi(n) = n*prod{(1-1/p)} (p prime factors)
# Use a seive to get all the primes, and calculate phi while we're at it.

use Lib;
my $target = 10**6;
my @phi = (0..$target);
my @prime = ((1) x ($target+1));
$prime[0] = $prime[1] = 0;
for(2..$#prime) {
	next unless $prime[$_];
	for(my $i=1; $i * $_ <= $target; $i++) {
		$phi[$i*$_] *= (1 - 1/$_);
		$prime[$i*$_] = 0;
	}
}

# 1/1 is not included, so subtract, 1
print (Lib::sum(@phi)-1)."\n";
