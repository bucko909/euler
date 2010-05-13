# Using 120, we are computing either  2a + 2 or 2na, mod a^2 n < a/2 for large
# primes so we can ignore the mod.

use Lib;

sub get_max {
	my ($a, $n) = @_;
	my $val = $n % 2 == 1 ? 2*$n*$a : 2*$a + 2;
	return $val;
}

my ($result) = Lib::flatten Lib::htake 1,
	Lib::hgrep { $_->[2] >= 10**10 }
	Lib::hmap { [ @$_, get_max (@$_) ] }
	Lib::hzip Lib::primes, Lib::naturals 1;
print "$result->[1]\n";
