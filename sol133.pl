# By previous problems we need to compute 10^(10^i) mod 9p and check if it is
# ever 1. Since 10^i = 1 mod 9p if and only if A(p) = (p-1)/k divides i, we
# must have (p-1)/k divides 10^i.
# Take k' the maximum power of 2 or 5 that divides p-1, then if
# 10^(10^i) = 1 mod 9p for some i then since (p-1)/k' divides (p-1)/k we must
# have 10^(10^k') = 1 mod 9p, so it's sufficient to check this.

# Original solution was a brute force using 132's method, but too 2 mins 44.

use Lib::NumberTheory;
use Lib::Lists;

sub is_used {
	my ($p) = @_;
	my $l = $p - 1;
	my ($e2, $e5) = (0, 0);
	($l, $e2) = ($l/2, $e2+1) while $l % 2 == 0;
	($l, $e5) = ($l/5, $e5+1) while $l % 5 == 0;
	my $e10 = $e2 > $e5 ? $e2 : $e5;
	my $k = Lib::binary_power_mod 10, 10**$e10, 9*$p;
	return $k == 1;
}

my $ans = Lib::sum
	Lib::flatten
	Lib::hgrep { !is_used($_) }
	Lib::hclip { $_ < 10**5 }
	Lib::primes;
print "$ans\n";
