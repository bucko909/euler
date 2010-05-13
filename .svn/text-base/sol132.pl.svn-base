# Walk through primes testing for factorisation. We know from previous
# questions that we need to compute 10^i mod 9p for each prime. i is going to
# be very high, though, so we need to be a bit clever.
# We don't need an optimal addition chain for 10^9 since the binary one is
# pretty short.
use Lib::NumberTheory;
use Lib::Lists;
my $p = Lib::Primes;
my $input = 10**9;
my $ans = Lib::sum
	Lib::flatten
	Lib::htake 40,
	Lib::hgrep { 1 == Lib::binary_power_mod 10, $input, 9*$_ }
	Lib::primes;

print "$ans\n";

# Unused notes on repunit factorisation:
# A repunit R(n) with n=ab is also composite:
#   R(ab) = R(a) * sum_{i=0}^b (10^{ia})
# The problem thus reduces to the simpler problem of factoring 2^9 * 5^9
# (easy), then looking at the factors of the resulting repunits.
# Call the other bit R(a,b). Note that R(cd,b) = R(c,bd) * R(d,b)
#
# R(6,2) = 10101010101 = 1000001 * 10101 = R(2,6) * R(3,2)
# R(2,6) = 1000001 = 10^6 + 1
#
# For example, R(10) = R(2*5) = R(2,5) * R(5) = R(5,2) * R(2)
