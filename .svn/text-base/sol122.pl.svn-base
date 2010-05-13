# Some research suggests this is a hard problem. There aren't many things that
# can be applied, and dynamic programming fails also. On the other hand, it is
# true that star chains, where at each stage the predecessor is added to one
# of its ancestors, are optimal for numbers up to around n=12000.
# The code assumes $target is below that number.

use strict;
use warnings;
# Lengths of best addition chains
my @length = (undef, 0);
# Holds array of ways to make each number optimally.
my @ancestors = (undef, [[1]]);

my $target = 200;
my $sum = 0;
for my $n (1..$target) {
	my $mylen = $length[$n];
	$sum += $mylen;
	for my $chain (@{$ancestors[$n]}) {
		for my $num (@$chain) {
			my $newn = $n + $num;
			last if $newn > $target;
			if (!defined $length[$newn] || $mylen + 1 < $length[$newn]) {
				$length[$newn] = $mylen + 1;
				$ancestors[$newn] = [ [ @$chain, $newn ] ];
			} elsif ($mylen + 1 == $length[$newn]) {
				push @{$ancestors[$newn]}, [ @$chain, $newn ];
			}
		}
	}
	undef $ancestors[$n];
}
print "$sum\n";
