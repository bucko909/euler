# If x+y=n^2 then x-y=(n-i)^2 so 2y=2ni-i^2, so i is even and 2y=4ni'-4i'^2
# so y=2(ni'-i'^2) and by the same argument z is even.
#
# x+y+z=(x+y+x+z+y+z)/2=(a^2+b^2+c^2)/2, so an odd number of the sum squares
# will be even. This expression also limits the search space somewhat. Note
# that x=(a^2+b^2-c^2)/2 so x, y, z can be recovered from this expression.
# y-z=(a^2-b^2+c^2+a^2-b^2-c^2)/2 = a^2-b^2 = d^2 and similar works for the
# others so the differences must be perfect squares.
use strict;
use warnings;
my $min = 10000000000;
for(my $a=4; ; $a++) {
	my $a2=$a*$a;
	last if $a2 > 2 * $min;
	for(my $b=3; $b<$a; $b++) {
		my $b2 = $b*$b;
		next unless test($a2-$b2);
		for(my $c=2; $c<$b; $c++) {
			my $c2 = $c*$c;
			next if $c2 + $b2 < $a2; 
			next unless test($a2-$c2);
			next unless test($b2-$c2);
			my $sum = ($a2+$b2+$c2)/2;
			if ($sum == int $sum && $sum < $min) {
				$min = $sum;
			}
		}
	}
}

print "$min\n";

sub test {
	my $t = sqrt($_[0]);
	return $t == int $t;
}
