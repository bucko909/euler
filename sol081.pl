# Skew the matrix into a trapezium. Now "right" is just "right", and "down" is
# "right and down", so we're moving strictly right.
# Work from left to right setting the entry in the ith row to the corresponding
# entry in the skewed matrix on the ith row, plus the minimum of the two to its
# left in the current path matrix.
# The answer will be in the bottom right of the path matrix.
open M, "matrix.txt";
while(my $m = <M>) {
	chomp $m;
	push @m, [ split /,/, $m ];
}
close M;
for(my $i=0; $i < @m; $i++) {
	for(my $j=0; $j < @m; $j++) {
		$n[$i][$i+$j] = $m[$i][$j];
	}
}
$o[0][0] = $n[0][0];
for(my $j=1; $j <= 2*$#n; $j++) {
	for(my $i=0; $i < @n; $i++) {
		my $n1 = $o[$i][$j-1];
		my $n2 = $o[$i-1][$j-1];
		next unless $n1 + $n2;
		$o[$i][$j] = (!$n1 || ($n2 && $n1 > $n2) ? $n2 : $n1) + $n[$i][$j];
	}
}
print "".$o[$#n][2*$#n]."\n";
