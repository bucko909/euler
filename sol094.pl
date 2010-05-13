# Area of a triangle is height*base/2 and must be integer. Noting that in the
# isoceles case we have height = sqrt(other^2 - (base/2)^2), so it seems we're
# once again after pythogorean triples.

# In the case where the base is of even length, we need a triple (x, y, z)
# such that z is the longest, and |2x - z| = 1. If this triple is not primitive
# then we have n divides 1 for n > 1, which is absurd.

# If the base is of odd length, we need a triple (x, y, z) such that z is
# longest, y, z are even and |x - z/2| = 1. Supposing hcf{x,y,z} is not a
# power of two we get a contradiction as above. If it is then 2 divides b which
# we assumed was odd.

# Use Euclid's formula which gives Pythagorean triples for any m >= n.
# a = 2*m*n
# b = m*m - n*n
# c = m*m + n*n
# if m>n are integers, hcf(m, n) = 1 and m + n = 1 mod 2, the above is
# primitive (note we don't need to check this, just ensure we generate all
# primitives).

# Note that c = z above is odd always, so no primitive triple has even longest
# side, and the base length must always be odd.

# 2b - c = m^2 - 3n^2 = +-1 ==> m = sqrt(3n^2+-1)
# c - 2a = m^2 + n^2 - 4mn = +-1 ==> m = (4n +- sqrt(12n^2 +-4))/2
#                  (taking negative)   =~ (4n - sqrt(3)2n) / 2 = 2n - 1.7n < n
# So we must take the positive square root.
#                                    m = 2n + sqrt(12n^2+-4)/2

# The perimeter is 2c + b or 2c + a, so we must have:
# 2c + b = 10n^2+-3 <= 10^9 ==> n <= 10000
# 2c + a = 8n^2+6n^2 +-1/2 + 5n sqrt(12n^2+-4) + 4n^2 <= 18n^2 ==> n < 10000
# So we have a very small set of candidates. Yay.
my @triples;
my $longest = 10000;
my $n = 0;
my @c;
my $count = 0;
for my $n (1..$longest) {
	for my $mt ([sqrt(3*$n**2 + 1),0], [sqrt(3*$n**2 - 1),0], [2*$n + sqrt(12*$n**2 + 4)/2,1], [2*$n + sqrt(12*$n**2 - 4)/2,1]) {
		my ($m, $t) = @$mt;
		if (int $m == $m) {
			my $c = $m**2 + $n**2;
			my $other;
			if ($t == 0) {
				$other = $m**2 - $n**2;
			} else {
				$other = 2 * $m * $n;
			}
			next unless (2*$other - $c)**2 == 1;
			print "$c-$c-".($other * 2)." ($m, $n)\n";
			my $perim = 2*$c+2*$other;
			print "Perimeter ($t/$n): $perim\n";
			next if $perim > 10**9;

			$count+=$perim;
		}
	}
}
print "$count\n";
