# Test vectors for axis intersections. Iff they intersect all 4, the origin is
# inside the triangle.
open TRIANGLES, "triangles.txt";
my $count = 0;
while(my $line = <TRIANGLES>) {
	$line =~ s/\s*$//;
	my @v = split /,/, $line;
	my @xaxis = (0, 0);
	my @yaxis = (0, 0);
	for(0..2) {
		my @base = ($v[0+$_*2], $v[1+$_*2]);
		my @end = ($v[(2+$_*2)%6], $v[(3+$_*2)%6]);
		my @between = ($end[0] - $base[0], $end[1] - $base[1]);
		if ($between[0] == 0) {
			# vertical
			$xaxis[sgn($base[0])] = 1;
		} elsif ($between[1] == 0) {
			# horizontal
			$yaxis[sgn($base[1])] = 1;
		} else {
			my $xinterceptn = $base[1] / $between[1];
			my $xintercept = $base[0] - $between[0] * $xinterceptn;
			if ($xintercept == 0) {
				# If a line goes through 0, 0 isn't in the interior.
				last;
			} elsif ($base[0] > $end[0] && $xintercept >= $end[0] && $xintercept <= $base[0]) {
				# These check the intercept occurs actually on the triangle.
				$xaxis[sgn($xintercept)] = 1;
			} elsif ($base[0] < $end[0] && $xintercept <= $end[0] && $xintercept >= $base[0]) {
				$xaxis[sgn($xintercept)] = 1;
			}
			my $yinterceptn = $base[0] / $between[0];
			my $yintercept = $base[1] - $between[1] * $yinterceptn;
			if ($yintercept == 0) {
				last;
			} elsif ($base[1] > $end[1] && $yintercept >= $end[1] && $yintercept <= $base[1]) {
				$yaxis[sgn($yintercept)] = 1;
			} elsif ($base[1] < $end[1] && $yintercept <= $end[1] && $yintercept >= $base[1]) {
				$yaxis[sgn($yintercept)] = 1;
			}
		}
	}
	my $sum = $xaxis[0] + $xaxis[1] + $yaxis[0] + $yaxis[1];
	$count++ if $sum == 4;
}
print "$count\n";

sub sgn {
	return (1+($_[0] <=> 0))/2;
}
