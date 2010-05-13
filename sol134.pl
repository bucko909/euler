# Note that if floor(log10 p1) = k then n = n'*10^{k+1} + p1 and p2 divides n.
# Since p2 does not divide p1 we have n'10^{k+1} % p2 = p2 - p1
# Thus excepting p2 = 2 (doesn't happen) and p2 = 5 we need to find such an n'.
# In the example we have 12*10^2 % 23 = 12 * 8 % 23 = 96 % 23 = 4.
# Now we need n' and m such that n' u - m p2 = p2 - p1.
# Since gcd(u,p2) = 1 we can find n' and m using extended Euclid algorithm.
# We then just need to adjust n' to ensure it's positive and minimal.

use Lib::NumberTheory;
use Lib::Lists;
use Lib::Utils;

my $ans = Lib::sum
	Lib::flatten
	Lib::hmap {
		my ($p1, $p2) = @$_;
		my $d = $p2 - $p1;
		my $k = int(log($p1)/log(10))+1;
		my $tenk = 10**$k;
		my $u = (10**$k) % $p2;
		my ($g, $n, $m) = Lib::gcd_coefficients($u, $p2);
		# $g == 1
		$n *= $d;
		# Make sure it's non-negative
		while ($n < 0) {
			$n += $p2
		}
		$n -= $p2 * int($n/$p2);
		$n*10**$k+$p1;
	}
	Lib::hgrep { $_->[0] > 3 }
	Lib::hclip { $_->[0] < 1000000 }
	Lib::hconsec
	Lib::primes;

print "$ans\n";
