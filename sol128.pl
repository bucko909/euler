# There are a number of properties that can easily be proven of PD:
# The starting values for the nth layer s(n) are 1, 2, 8, 20.
# s(2) = 2, s(n) = s(n-1) + 6*(n-2), so s(n) = 3(n-1)(n-2) + 2
#
# We assume everything is on layer 3 or above.
# PD(1) = 3, PD(2) = 3, PD(3) = 2, PD(4) = 2, PD(5) = 0, PD(6) = 2, PD(7) = 2
#
# For a tile which does not start or end a new layer, PD(n) loses 2, as
#   |n-1-n| = |n+1-n| = 1
#
# For a "line" tile n, which does not end a layer, PD(n) is at most 2, since
# at most one of each pair of inside and outside tiles is prime (each pair
# differs by exactly 1), and the remainder are not prime.
#
# For a terminal "line" tile s(k+1)-1, it is followed by s(k), with difference
# 6*(k-1)-1 = 6k-7. The outer tiles have differences s(k+2)-l-s(k+1)-1 = 6k
# (not prime) and 6k-1. The inner tiles have differences 6*(k-1) (not prime)
# and s(k+1)-1-s(k-1) = 6*(k-1) + 6*(k-2) - 1 = 12k - 19. So each of these 3
# must be tested for primality.
#
# For a "corner" tile which does not start a new layer, there are at most 3. At
# most two outsides tile are prime, and no adjacent tiles are prime. Labelling
# anticlockwise from 0 on layer k, the corners are s(k) + i*(k-1), so the
# difference to the inner is 6*(k-2) + i (not prime for i=0,2,3,4). The outer
# tiles differences are 6*(k-1) + i - 1, 6*(k-1) + i and 6*(k-1) + i + 1. For
# i=0,2,3,4 the middle isn't prime, for i=1,3,4,5 the lower isn't and for
# i=1,2,3,5 the upper isn't. We want exactly 3 of these 4 to be prime, so have
# eliminated all nonzero i.
#
# For i=0, the below and above tiles do not give primes by the above. The top
# left is 6k-5, the previous is 6k-7 and the top right is 12k-7.

use Lib::NumberTheory;
my $prime_cache12k19 = 1; # Stores the upper-right difference
my $prime_cache6k7 = 1; # Stores the lower-right difference
my $found = 2;
my $target = 2000;
for(my $k = 3; ; $k++) {
	my $p1 = Lib::is_prime($k*6-5);
	my $p2 = Lib::is_prime($k*6-1);
	my $p3 = Lib::is_prime($k*12-7);
	# Initial
	if ($prime_cache6k7 && $p1 && $p3) {
		my $n = 3*($k-1)*($k-2) + 2;
		$found++;
		if ($found == $target) {
			print "$n\n";
			last;
		}
	}
	# Terminal
	if ($prime_cache12k19 && $prime_cache6k7 && $p2) {
		my $n = 3*$k*($k-1) + 1;
		$found++;
		if ($found == $target) {
			print "$n\n";
			last;
		}
	}
	$prime_cache12k19 = $p3;
	$prime_cache6k7 = $p2;
}
