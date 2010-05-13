# Since the square is a multiple of 10, so is the original, so if n=a_9...a_0
# then a_0 = 0. If n^2 = b_18..b_0 then b_0=b_1=0, and b_i = c_i % 10 where
# c_{2i} = a_i^2 + sum_{j=1}^{i-1} a_{i+j}a_{i-j} + floor(c_{2i-1}/10)
# c_{2i+1} = 2sum_{j=1}^i a_{i+j}a_{i-j+1} + floor(c_{2i}/10)
# Thus, the highest a_j used in c_i is a_{i-1}
#
# Armed with this, it should be possible to approach the problem; each new
# digit from the right adds two extra possible digits to the start of our
# candidate n by solving the above equations.
# 
# Reducing the problem this way finds about 7500 possibilitie for the last 9
# digits. We know there's 10 digits and the first two are between 10 and 14, so
# just try each combination.

use strict;
use warnings;
sub checknext {
	my ($remainder, @digarray) = @_;
	my $n1 = @digarray;
	my $aim = (9 - $n1 / 2) % 10;
	my $mul = $digarray[1] * 2;
	for my $a_2i (0..9) {
		# Work out the values of the odd bit.
		$digarray[$n1] = $a_2i;
		my $b_2i_1 = $remainder;
		$b_2i_1 += 2 * $digarray[$_] * $digarray[$n1+1-$_] for (1..($#digarray+1)/2);
		my $add = int($b_2i_1/10);
		$add += $digarray[$_] * $digarray[$n1 + 2 - $_] for 2..$n1;
		next if $add % 2 != $aim % 2;
		for my $a_2i_1 (0..4) {
			# Noting that a_i always has an even multiple, and 2(b+5) = 2b mod
			# 10, there's no need to check higher values.
			next if ($add + $mul * $a_2i_1) % 10 != $aim;
			if (@digarray < 9) {
				checknext(int(($add + $mul * $a_2i_1)/10), @digarray, $a_2i_1);
				checknext(int(($add + $mul * ($a_2i_1+5))/10), @digarray, $a_2i_1 + 5);
			} else {
				my $n = join '', reverse @digarray, 1;
				my $n2 = $n * $n;
				if ($n2 =~ /^1.2.3.4.5.6.7.8.9.0$/) {
					print "$n\n";
					exit;
				}
			}
		}
	}
}

checknext(0, 0, 3);
checknext(4, 0, 7);
