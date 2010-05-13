# Note that we have (a,b,k(b-c)) a pyth triple for some k.
#
# So a^2+b^2-k^2(b^2-2bc+c^2)=0
# so (1-k^2)a^2+2k^2bc+(1-k^2)b^2=0
# This is a diophantine equation for each k.
# For solutions to exist, k^4-(1-k^2)^2=2k^2-1 is a perfect square.
# Plug into Dario's solver: (1,1) and (a,b)->(3a+2b,4a+3b).
# The diophantine equation factorises: 
# ((1-k^2)x + (k^2+sqrt(2k^2-1))y)((1-k^2)x + (k^2-sqrt(2k^2-1))y)=0
# Let g=gcd(k^2-1,k^2+sqrt(2k^2-1)), d=k^2-1, e=k^2+sqrt(...), e'=...-...
# Then there are solutions t*(e/g,d/g) and t*(e'/g,d/g) for each t. We require
# that t(e/g+d/g+sqrt((e/g)^2+(d/g)^2)) < 100000000
# It turns out that (e',d) is an equivalent solution to (e,d), so use only
# e.

use Lib::NumberTheory;
use strict;
use warnings;

my $target = 100000000;
my ($a, $b) = (1, 1);
my $count = 0;
while($a < $target) {
	($a, $b) = (3*$a+2*$b, 4*$a+3*$b);
	my $d = $a*$a-1;
	my $e = $a*$a+$b;
	my $g = Lib::gcd($d,$e);
	my $s = $e/$g+$d/$g+sqrt(($e/$g)**2+($d/$g)**2);
	$count += int($target/$s);
	last if $a > $target;
}
print "$count\n";
