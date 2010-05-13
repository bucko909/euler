# Work from left to right, setting the value in the path matrix to the value
# in the matrix plus the minimum of paths heading up and down to it, after
# heading right. That is, paths like the below.
# 
# -\ 
#  |    
#  |   -\
#  |    |
#  *    *   -*    *
#                -/
#
# TODO this solution is fast enoug, but slightly inefficient. For each column,
# One only needs to compute all minimum upward and downward sums, then find the
# minimum at each point. this will remove a degree on the polynomial for the
# runtime on large matrices.

open M, "matrix.txt";
while(my $m = <M>) {
	chomp $m;
	push @n, [ split /,/, $m ];
}
close M;
for(my $i=0; $i < @n; $i++) {
	for(my $j=0; $j < @n; $j++) {
		$m[$j][$i] = $n[$i][$j];
	}
}
$o[0][$_] = $m[0][$_] for(0..$#m);
for(my $i=1; $i < @m; $i++) {
	for(my $j=0; $j < @m; $j++) {
		$min = 1000000000000000000;
		for(my $k=0; $k < @m; $k++) {
			my $sum = $o[$i-1][$k];
			if ($k > $j) {
				$sum += $m[$i][$_] for($j..$k);
			} else {
				$sum += $m[$i][$_] for($k..$j);
			}
			if ($sum < $min) {
				$min = $sum;
			}
		}
		$o[$i][$j] = $min;
	}
}
my $min = 100000000000000000;
for(@{$o[$#o]}) {
	$min = $_ if $_ < $min;
}
print "$min\n";
