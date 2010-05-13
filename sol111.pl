# Exactly what it says on the tin. Loop though possible "choice" positions, and
# loop through candidate digits for them. The only innovative stuff is ensuring
# the first digit of 0 is chosen, and culling bad final digits early.

use Lib;
use strict;
use warnings;
my $len = 10;
my $maxprime = 10**($len/2);
my @primes = Lib::flatten Lib::hclip { $_ < $maxprime } Lib::primes;
my $sum = 0;
for my $digit (0..9) {
	my @choose = ();
	my $primesum = 0;
	my $primelength;
	while(1) {
		Lib::listinc_shortlex_strict_increasing {
			for(@{$_[0]}) {
				return if $_ >= $len;
			}
		 	return if $_[0][0] > 0 && $digit == 0;
			return 1;
		} \@choose, 0;
		if ($digit % 2 == 0 || $digit == 5) {
			next if $choose[$#choose] != $len-1;
		}
		last if $primelength && @choose > $primelength;
		my @choices = (($len-1) x (@choose - 1));
		candidate: while(1) {
			Lib::listinc_shortlex {
				return if @{$_[0]} < @choose;
				for(@{$_[0]}) {
					return if $_ > 8;
				}
				return 1;
			} \@choices, 0;
			next if $choose[0] == 0 && $digit != 0 && $choices[0] == 0;
			last if @choices != @choose;
			my $pos = -1;
			my $num = '';
			for(0..$#choose) {
				$num .= $digit x ($choose[$_] - $pos - 1);
				my $choice = $choices[$_];
				$choice++ if $choice >= $digit;
				$num .= $choice;
				$pos = $choose[$_];
			}
			$num .= $digit x ($len - length $num);
			my $temp = $num;
			for(my $i=0; ; $i++) {
				my $a = $primes[$i];
				last unless $primes[$i];
				last if $a > $temp;
				if ($temp % $a == 0) {
					next candidate;
				}
			}
			$primesum += $num;
			$primelength = @choose;
		}
	}
	$sum += $primesum;
}
print "$sum\n";
