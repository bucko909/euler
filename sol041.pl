# Note that the prime can't be 8 or 9 digit as all pandigitals of those
# lengths divide by 9.
use Lib;
use strict;
use warnings;
my @digits = (1..6);
my @pos = ((9)x 5);
my $ans;
while(1) {
	Lib::listinc_shortlex {
		return if @{$_[0]} < 6;
		for(my$a=5;$a>=0;$a--) {
			return if $_[0][$a] > 5 - $a;
		}
		return 1;
	} \@pos, 0;
	last if @pos > 6;
	my $p = 7;
	my @digits2 = @digits;
	for(@pos) {
		$p .= splice(@digits2,$_,1);
	}
	next unless Lib::is_prime($p);
	$ans = $p;
}
print "$ans\n";
