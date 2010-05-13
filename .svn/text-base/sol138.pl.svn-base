# (b/2)^2+h^2=L^2 so b must be even. Let b=2k. So h=b+-1=2k+-1
# k^2+(2k+-1)^2=L^2
# 5k^2+-4k+1-L^2=0
# A positive x in the + solution is equivalent to a negative x in
# the - solution and vice versa. Similarly y can always be negated.
# So plug just the +4x equation into Dario Alpern's equation solver
# and take absolute values.
# There are two given base values, but 0,-1 leads to 0,1 so ignore
# it.
use Lib::Diophantine;
use Lib::Lists;
use strict;

my ($a, $b) = (0,1);
my $ans = 0;
for(1..12) {
	($a, $b) = (-9*$a-4*$b-4, -20*$a-9*$b-8);
	$ans += abs($b);
}
print "$ans\n";

=cut

my @arr = sort { $a <=> $b } Lib::flatten
	Lib::hmap { $_->[0] }
	Lib::hclip { defined $_ }
	Lib::hinterleave(
		Lib::htake(12, Lib::diophantine_solve(5,0,-1,4,0,-1)),
		Lib::htake(12, Lib::diophantine_solve(5,0,-1,-4,0,-1)),
	);
my $ans = Lib::sum @arr[0..11];
print "$ans\n";
