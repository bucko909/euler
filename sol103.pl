# First, assume (0) the list is in strictly increasing order.
#
# Now, the second rule (2) is trivially equivalent to satisfying all of:
#              a[1] > 0
#       a[1] + a[2] > a[n]
#                  ...
# a[1] + ... + a[i] > a[n] + ... + a[n-i+2]
# It's easy to see from these that any other sets B, C of size i+1 and j<=i
# will have S(B) > S(C) as S(B) > S(a[1], ..., a[i-1]) and
# S(C) < S(a[n-i+2], ..., a[n])
#
# The first rule is harder, but assuming both of the above, we know that to
# check it we may assume that the sizes of the subsets are equal (2). Using (0)
# there are only a few cases for each size. I list the elements of both sets in
# order using ^ for B and . for C. I assume that the least element is in B.
# Size 1: No possibilities.
# Size 2:
# ^..^
# Size 3:
# ^^...^   ^.^..^   ^..^.^   ^...^^   ^..^^.
# Note that these sets can all be formed by picking a point in the size 2 set
# and adding either an element to B then to C or vice versa.
#
# Our strategy, then, is to start with [1, ..., n] and repeatedly test for the
# above rules, adding to the smallest element possible in order to "fix" the
# problem. Once we have such a set we can increment to the lex next and fix
# until the sum gets too high. Rinse, repeat until the first element is too
# large.

use Lib;

my $n = 7;
my @attempt = (1..$n);
my $minsum = 1000000000000;
my $best;
attempt: while(1) {
	# Check sanity. If a[0] is too big we should quite now.
	last if $n * ($attempt[0] - 1) + $n * ($n + 1) / 2 > $minsum;
	my $sum = Lib::sum(@attempt);
	if ($attempt[0] * 2 < $attempt[1]) {
		@attempt = ($attempt[0]+1 .. $attempt[0]+$n);
		next;
	}
	if ($sum > $minsum) {
		my $i = $n-2;
		while($i >= 1) {
			if ($attempt[$i+1] > $attempt[$i]+1) {
				my $presum = Lib::sum(@attempt[0..$i-1]);
				# Laziness for the next one!
				my $postsum = Lib::sum($attempt[$i]+1..$attempt[$i]+$n-$i);
				last if $presum + $postsum < $minsum;
			}
			$i--;
		}
		$attempt[$i]++;
		$attempt[$_+1] = $attempt[$_]+1 for($i..$n-2);
	}
	# Assume (0), that it's increasing. That's easy to force.
	# Test (2).
	for my $i (1..int(($n-1)/2)) {
		my $sum1 = Lib::sum(@attempt[0..$i]);
		my $sum2 = Lib::sum(@attempt[$n-$i..$n-1]);
		if ($sum1 <= $sum2) {
			# It's bad. Must fix.
			if ($n > 2*$i - 1) {
				# There's some leftover. We can increment that first, maybe?
				my $try = $n - $i - 1;
				my $remain = $n - $try + 1;
				while($try > $i) {
					if ($attempt[$n-1] - $attempt[$try] < $remain + 1) {
						$try--;
						$remain++;
					} else {
						$attempt[$try]++;
						for($try+1..$n-1) {
							$attempt[$_] = $attempt[$_-1]+1;
						}
						next attempt;
					}
				}
			}
			$attempt[$i]++;
			for($i+1..$n-1) {
				$attempt[$_] = $attempt[$_-1]+1;
			}
			next attempt;
		}
	}
	# Test (1)
	# Size 2:
	if ($n >= 4) {
		my @test = ();
		while(1) {
			Lib::listinc_shortlex_strict_increasing {
				return if @{$_[0]} != 4;
				return if $_[0][3] > $n - 1;
				return 1;
			} \@test;
			last if @test > 4;
			next if @test < 4;
			if ($attempt[$test[0]] + $attempt[$test[3]] == $attempt[$test[1]] + $attempt[$test[2]]) {
				$attempt[$test[3]]++;
				for($test[3]+1..$n-1) {
					$attempt[$_] = $attempt[$_-1]+1;
				}
				next attempt;
			}
		}
	}
	# Size 3
	if ($n >= 6) {
		my @test = ();
		while(1) {
			Lib::listinc_shortlex_strict_increasing {
				return if @{$_[0]} != 6;
				return if $_[0][5] > $n - 1;
				return 1;
			} \@test;
			last if @test > 6;
			next if @test < 6;
			for my $order([0,0,1,1,1,0],[0,1,0,1,1,0],[0,1,1,0,1,0],[0,1,1,1,0,0],[0,1,1,0,0,1]) {
				my @sums = (0, 0);
				$sums[$order->[$_]] += $attempt[$test[$_]] for(0..5);
				if ($sums[0] == $sums[1]) {
					$attempt[$test[5]]++;
					for($test[5]+1..$n-1) {
						$attempt[$_] = $attempt[$_-1]+1;
					}
					next attempt;
				}
			}
		}
	}
	if ($sum < $minsum) {
		$best = join('',@attempt);
		$minsum = $sum;
	}
	$attempt[$n-1]++;
}
print "$best\n";
