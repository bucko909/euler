# Brute force. Generate the primes and check for the required property.
# Note that we can drop anything with digits 0, 2, 4, 5, 6, 8 in. Thus we only
# care about primes with only 1, 2, 3, 5, 7, 9 in them. 2 and 5 can only appear
# as the final digit
use Lib;
use strict;
use warnings;
my @primes = Lib::flatten Lib::hclip { $_ <= 1000 } Lib::primes;
my @digits = (1, 2, 3, 5, 7, 9);
my $sum = 0;
for my $length (2..6) {
	seq: for my $seq (0..6**$length-1) {
		my $n = 0;
		my $temp = $seq;
		my $loops = 0;
		while($loops++ < $length) {
			# 2 and 5 are no good after the start.
			if ( $length > 1 && $loops > 1
				&& ($temp % 6 == 1 || $temp % 6 == 3) ) {
				next seq;
			}
			$n *= 10;
			$n += $digits[$temp%6];
			$temp = int($temp/6);
		}
		my $new = $n;
		for my $cut (1..$length) {
			next seq if $new <= 1;
			for my $p (@primes) {
				last if $p >= $new;
				next seq if $new % $p == 0;
			}
			$new = int($new / 10);
		}
		$new = $n;
		for my $cut (1..$length-1) {
			$new = substr($new,1);
			next seq if $new <= 1;
			for my $p (@primes) {
				last if $p >= $new;
				next seq if $new % $p == 0;
			}
		}
		$sum += $n;
	}
}
print "$sum\n";
