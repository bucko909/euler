# This is a depressing brute force. My initial attempt was to try to eliminate
# edges which could not be a part of an optimal triangle, but it didn't work out
# faster.

# However, the sum for N should be roughly normally distributed. The variance
# for one is just 2*2^19*(2^19+1)(2^20+1)/6/2^20 =~ 2^37. Sum the variances and
# find that for a triangle of side length n, variance is about 2^36*n(n+1), so
# standard deviation is about 2^18n for large n. This is complete rubbish,
# though, as there will be a lot of covariance between triangles. Therefore,
# just ensure we're about 20% from the standard deviation and all should be
# fine.

# Note that the forum suggests a more efficient overlapping triangles method
# using area(x,y,l) = area(x,y+1,l-1)+area(x+1,y,l-1)-area(x+1,y+1,l-2)+a[x][y]
# I think it's basically the same way as this though.

# Generate
my $t = 0;
my $x = 0;
my $y = 0;
my $twotwenty = 2**20;
my $twonineteen = $twotwenty / 2;
my @arr = [];
for(1..500500) {
	$t = (615949*$t+797807) % $twotwenty;
	$arr[$y][$x] = $t - $twonineteen;
	$x++;
	if ($x > $y) {
		$x = 0;
		$arr[$x] = [];
		$y++;
	}
}

my $min = 0;
my $max = 0;
for my $x (0..$#arr) {
	# Assume the triangle will be using x=$x. Then the sum along here must be
	# negative.
	#
	# Find a negative region.
	my @tots;
	for my $y ($x..$#arr) {
		my $len = $y-$x;
		$tots[$y-$x] = 0;
		my $subtot = 0;
		for my $x2 (0..$y-$x) {
			$subtot += $arr[$y][$x+$x2];
			$tots[$len-$x2] += $subtot;
			if ($tots[$len-$x2] < $min) {
				$min = $tots[$len-$x2];
			} elsif ($tots[$len-$x2] > $max) {
				$max = $tots[$len-$x2];
			}
		}
	}
	last if ($#arr-$x) < -$min/1.1/2**18;
}

print "$min\n";
