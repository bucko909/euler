# We can brute force this one.
use Lib;
# @v is to be the test vector.
# We start from 1 as no vector with a right angle is lex less than (0, n).
my $limit = 50;
my @v = (0, 0);
my $count = 0;
while(1) {
	Lib::listinc_shortlex {
		return if $_[0][0] > $limit || $_[0][1] > $limit;
	} \@v;
	last if @v > 2;
	# Where could the right angle be?
	if ($v[1] == 0) {
		# At the origin? Only if $v[1] == 0.
		$count += $limit;
	}
	
	# At v?
	if ($v[0] != 0 && $v[1] != 0) {
		# If so, the other one must have w[0] <= v[0].
		# Let k = w - v, with k0 < 0, and let v' be a multiple of v with
		# hcf{v'0,v'1} = 1. Then k1 is a positive multiple of v'0:
		# v'0 k0 + v'1 k1 = 0 ==> k0 = -k1 (v'1 / v'0) = -n v'1
		# so n <= v0 / v'1
		my ($a, $b) = @v;
		while($b != 0) {
			my $ne = $a % $b;
			$a = $b;
			$b = $ne;
		}
		my @v2 = ($v[0] / $a, $v[1] / $a);

		my $leftn = int(($limit - $v[1])/$v2[0]);
		$leftn = int($v[0]/$v2[1]) if $leftn * $v2[1] > $v[0];
		$count += $leftn;

		# That took care of triangles with the right angle at their lex-least
		# nonzero point. Now we can go in the other direction.
		my $rightn = int(($limit - $v[0])/$v2[1]);
		$rightn = int($v[1]/$v2[0]) if $rightn * $v2[0] > $v[1];
		$count += $rightn;
	} else {
		# If we're on-axis, it's just anything above us vertically.
		$count += $limit;
	}
}
print "$count\n";
