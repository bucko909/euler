# This is a lot like the other fibonacci one, except the fibs involved are
# different. Wikipedia offers a proof that any Fib-like sequence looks like
# aG^n + bG'^n where G and G; are the golden and conjugate golden ratios.
# a  + b = 1
# aG + bG' = 4
# So b(G'-G) = b(1-2G) = -b sqrt(5) = 4-G = (7-sqrt(5))/2
# and b = (G-4)/sqrt(5) = (sqrt(5)-3)/2sqrt(5) = (5-7sqrt(5))/10
# a(G-G') = a sqrt(5) = 4-G' = 3 + G = (7+sqrt(5))/2
# so a = (5+7sqrt(5))/10
#
# Now k = A_F(x) = x\sum(a(Gx)^n+b(G'x)^n)
# = x(a/(1-Gx)+b/(1-G'x))
# = x(a(1-G'x)+b(1-Gx))/(1-Gx)(1-G'x)
# = x((5+7sqrt(5))(1-G'x) + (5-7sqrt(5))(1-Gx))/10(1-x-x^2)
# = x(10-5x(G+G')+7xsqrt(5)(G-G'))/10...
# = x(10-5x+35x)/10(1-x-x^2)
# = x(1+3x)/(1-x-x^2)
# so k-(k+1)x-(k+3)x^2 = 0 or (k+3)x^2+(k+1)x-k=0
# x = (-k-1+-sqrt((k+1)^2+4k(k+3)))/2(k+3) is rational
# so 5k^2+14k+1 is a perfect square. Solve the diophantine equation using
# Dario Alpern's solver.

use Lib::Utils;
use strict;
use warnings;

my @nugs;
# The 4,5 ones generate the 2,7 ones, and start with negative x so ignore them.
#for my $start ( [0,-1], [0,1], [-3,-2], [-3,2], [-4,-5], [-4,5], [2,-7], [2,7] ) {
for my $start ( [0,-1], [0,1], [-3,-2], [-3,2], [2,-7], [2,7] ) {
	my ($x, $y) = @$start;
	while(1) {
		if ($x > 0) {
			if (@nugs < 30 || $nugs[29] > $x) {
				if (!grep { $_ == $x } @nugs) {
					push @nugs, $x;
					@nugs = sort { $a <=> $b } @nugs;
					@nugs = @nugs[0..(@nugs>30?29:$#nugs)];
				}
			} else {
				last;
			}
		}
		($x, $y) = (-9*$x-4*$y-14,-20*$x-9*$y-28);
	}
}
my $ans = Lib::sum @nugs;
print "$ans\n";
