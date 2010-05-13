# Approach from reverse by looping over the sets of digits rather than the
# numbers. Then just check the result fits the digits we started with.
use Lib;
my @digits = (1);
my $sum = 0;
while(1) {
	Lib::listinc_shortlex_increasing {
		for(@{$_[0]}) {
			return if $_ > 9
		}
	} \@digits, 0;
	last if 9**5*@digits < 10**(@digits-1);
	my $dsum = Lib::sum map { $_ ** 5 } @digits;
	my @digits2 = sort split //, $dsum;
	$sum += $dsum if "@digits2" eq "@digits";
}
print "$sum\n";
