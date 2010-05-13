# No "new" sides can be created in the production of the Minkowski sum - since
# the result is convex, each resulting side is just one of the original shapes'
# sides. Number the sides of S_n 0 to n-1. The side is shared if
# i/(n-1) = i/(m-1) as the angle of the tangent to side i is pi*i/(n-1) + pi/2.
# A simple approach is thus to just keep a bunch of fractions and check
# equality.

# As it's related to coprimality, there will be a solution using the Euler phi
# function, factorising the numbers etc. to find the number of fractions, but
# as the range is so small (lifespan of Minkowski), there seems little point.
my %hash;
for my $sides (1864..1909) {
	for my $sno (0..$sides-1) {
		$hash{$sno/$sides} = 1;
	}
}
my $ans = keys %hash;
print "$ans\n";
