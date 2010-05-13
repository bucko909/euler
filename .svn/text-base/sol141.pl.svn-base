# Have n^2=dq+r with r<d, {d,q,r} = k{1,x,x^2}
# Assume x>1 so r=1 or r=x. If r=1, n^2=k(kx^3+1). If r=x, n^2=kx(kx+1)
# Also, since f,q,r are integers, k, kx, kx^2 are integers so x is rational.
# So b^3n^2=k(ka^3+b^3) and b^2n^2=ka(ka+b) are integer
# equations. We can suppose a,b,k>0, and since x>1, a>b. May as well assume
# a,b are coprime.
#
# For the first equation, b^3(n^2-k)=k^2a^3 note that b^2|k or ka^2/b^2 is not
# and integer.
# So (n^2-b^2k')=bk'^2a^3 and n^2=bk'(k'a^3+b). This is for given a,b a quad
# diophantine equation but I solve it fot k with brute force.
#
# For the other equation, b^2n^2=ka(ka+b) note that a, b are coprime, so
# if p^i|b and then p^j|(ka+b) (so p^j|ka) and p^l|ka with j+l>=2i. So
# p^i|k. Then b|k, so n^2=k'a(k'a+1). The only solutions to this have n=0.
#
# It seems like the set of 'b' searched here is much higher than is strictly
# needed, and a lot of unnecessary as are probably searched also.

use Lib;
use strict;
use warnings;
my $target=10**12;
my $maxs=int(sqrt($target));
my @arr = ((0) x ($maxs+1));
# Assume a=b, k'=1
# n^2=a^2(a^2+1)>a^4
my $maxb = int($target**(1/4));
my $b = 0;
while($b++ < $maxb) {
	my $b3 = $b**3;
	my $a = $b;
	my $maxa3 = int(($target/$b-$b)**(1/3));
	while($a++ < $maxa3) {
		my $k = 1;
		my $a3 = $a**3;
		my $n = sqrt($b*($a3+$b));
		while ($n < $maxs) {
			if (int $n == $n) {
				$arr[$n] = 1;
				print "$a $b $k\n";
			}
			$k++;
			$n = sqrt($k*$b*($k*$a3+$b));
		}
	}
}
print "".Lib::sum(map { $_ * $_ } grep { $arr[$_] } 1..$maxs)."\n";
