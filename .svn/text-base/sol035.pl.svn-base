# Brute force. Generate the primes and check for circularity.
# Note that we can drop anything with digits 0, 2, 4, 5, 6, 8 in. Thus we only
# care about primes with only 1, 3, 7, 9 in them.
# There's 4^6 + ... + 4^1 < 6000 of them.
use Lib;
use strict;
use warnings;
my @primes = Lib::flatten Lib::hclip { $_ <= 1000 } Lib::primes;
my @digits = (1, 3, 7, 9);
my $count = 1; # 2 and 5, but skip 1.
for my $length (1..6) {
	seq: for my $seq (0..4**$length-1) {
		my $n = 0;
		my $temp = $seq;
		my $loops = 0;
		while($loops++ < $length) {
			$n *= 10;
			$n += $digits[$temp%4];
			$temp = int($temp/4);
		}
		my $new = $n;
		my $pow = 10**($length-1);
		for my $cyc (1..$length) {
			for my $p (@primes) {
				last if $p >= $new;
				next seq if $new % $p == 0;
			}
			$new = $pow*($new%10)+int($new/10);
		}
		$count++;
	}
}
print "$count\n";
