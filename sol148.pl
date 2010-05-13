# The answer is 7 divides an entry (n,r) if:
# sum floor(n/q) > sum floor(r/q) + floor((n-r)/q)
# for some q=p^i
#
# floor(i/q) = (i - (i%q)) / q, so need to check r%q + (n-r)%q - n%q > 0
# Note that (n-r)%q = (-(r%q)+n%q)%q
# If r%q <= n%q then (n-r)%q=n%q-r%q and the difference is 0.
# If r%q > n%q then (-(r%q)+n%q) = n%q - r%q + q so that the difference is q.
#
# There is a pretty obvious pattern at work here.
# If        n < p there are 0 working dividing bits.
# If        n < p^2 there are floor(n/p) * (n % p) that don't divide
# If p^2 <= n < p^3 there will be some overlap.
#
# The previous pattern always gets repeated, BUT there are a bunch of extras
# thrown in by the new prime power. Between p^2 and 2p^2
#
# Each term is 0 n%p times out of p (as there are n%p possible values of r%p).
# If it's 0 on the first term, there are (floor(n/7)-1)%7 out of 7 ways for the
# next bit to be 0.
#
# All this leads to blocks of (blocks of ...) triangles which are adjacent and
# of prime length which do /not/ have the prime as a divisor. They are
# recursively placed in triangles of the same dimensions.

use strict;
use warnings;
my $prime = 7;
my $target = 1000000000;
my $length = $prime;
my $area = $prime*($prime+1)/2;
my @areas;
while ($length < $target) {
	push @areas, $area;
	$length *= $prime;
	$area *= $prime*($prime+1)/2;
}
my $remain = $target;
my $sum = 0;
my $multiplier = 1;
for my $size (reverse (0..$#areas)) {
	my $length = $prime ** ($size+1);
	my $depth = 0;
	$depth++ while $length * ($depth + 1) <= $remain;
	$remain -= $length * $depth;
	$sum += $multiplier * $areas[$size] * $depth * ($depth + 1) / 2;
	$multiplier *= $depth + 1;
}
$sum += $multiplier * $remain * ($remain + 1) / 2;
print "$sum\n";

=cut
# Work out areas of /used/ divisors
my $last = 0;
my $val = $prime;
my @areas;
for(1..1000) {
	last if $val > $target;
	push @areas, $last;
	$last *= $prime * ($prime + 1) / 2;
	$last += ($val * ($val - 1) / 2) * ($prime * ($prime - 1) / 2);
	$val *= $prime;
}
