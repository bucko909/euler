# Loop over the sets of digits and test if the sum of the factorials first the
# original digits.
use Lib;
use strict;
use warnings;
my @digits = (2);
my @fac = map { Lib::fac($_) } 0..9;
my $sum = 0;
outer: while(1) {
	my $num = Lib::listinc_shortlex_increasing {
		return if $_[0][$#{$_[0]}] > 9;
		my $num = Lib::sum map { $fac[$_] } @digits;
		return if $num >= 10**@digits;
		return $num;
	} \@digits;
	last if @digits * $fac[9] < 10 ** (@digits-1);
	my @newdigits = sort split //, $num;
	next if @newdigits != @digits;
	for(0..$#digits) {
		next outer if $digits[$_] != $newdigits[$_];
	}
	$sum += $num;
}
print "$sum\n";
