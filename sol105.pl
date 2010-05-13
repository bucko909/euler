# Use a recursive check for Rule i.
#
# For a string w in {A,B}^*, and a tuple C, put C(i) in A if w(i) = A, and in
# B if w(i) = B.
#
# For sets of size one, we just need to check AB for |C| = 2. But that's always
# OK.
#
# For sets of size two, we just need to check ABBA (ABAB is just the first case
# again).
#
# For sets of size n, pick C' = C(1), ..., C(i), C(i+3), ..., C(n)
# Test C' as a set of size n-1, then if S(A) > S(B), add AB, else add BA into
# the gap.

use Lib;
use strict;
use warnings;

our $tests;

sub test1_check {
	my ($sum, @bits) = @_;
	return 0 if $sum == 0;
	return 1 if @bits == 0;
	for (0..$#bits) {
		my $add;
		if ($sum > 0) {
			$add = $bits[$_][0] - $bits[$_][1];
		} else {
			$add = $bits[$_][1] - $bits[$_][0];
		}
		my $ret = test1_check($sum + $add, @bits[0..$_-1,$_+1..$#bits]);
		return 0 unless $ret;
	}
	return 1;
}

sub test1 {
	my ($sub, $arr, $earlyclip, $skipped_id, $ok_to_recurse, @bits) = @_;
	$skipped_id = -1 if !defined $skipped_id;
	$ok_to_recurse = 1 if !defined $ok_to_recurse;
	$arr ||= [ 0..$#$sub ];
	$earlyclip ||= 0;
	print "test(@$sub, @$arr, $earlyclip, ".join(', ', map { "@$_" } @bits).")\n";
	if (@$arr < 4) {
		print "Auto-success.\n";
		return 1;
	} elsif (@$arr == 4) {
		print "Terminal node.\n";
		my $sum = $sub->[$arr->[0]] + $sub->[$arr->[3]] - $sub->[$arr->[1]] - $sub->[$arr->[2]];
		return test1_check($sum, @bits);
	} else {
		print "Recursion.\n";
		if (@$arr % 2 == 1) {
			# Just clip off an element.
			for(0..$#$arr) {
				my @temp_id = @{$arr}[0..$_-1,$_+1..$#$arr];
				my $ret = test1($sub, \@temp_id, 0, $_, 1, @bits);
				return 0 unless $ret;
			}
			return 1;
		}

		# for each possible hole position
		for my $first ($earlyclip..4) {
			for my $second ($first+1..$#$arr) {
				my @temp_id = @{$arr}[0..$first-1,$first+1..$second-1,$second+1..$#$arr];
				my $ok_to_recurse_new;
				if ($second != $first + 1) {
					$ok_to_recurse_new = 0;
				} else {
					$ok_to_recurse_new = $ok_to_recurse;
				}
				my $skipped_id_new;
				if ($skipped_id >= 0 && $arr->[$first] < $skipped_id) {
					$skipped_id_new = -2;
				} else {
					$skipped_id_new = $skipped_id;
				}
				my $ret = test1($sub, \@temp_id, $first, $skipped_id_new, $ok_to_recurse, @bits, $ok_to_recurse_new ? ([@{$sub}[$arr->[$first],$arr->[$second]]]) : ());
				return 0 unless $ret;
			}
		}
		return 1;
	}
}

test1([1,2,3,4,5,6,7,8]);

sub test2 {
	my ($set) = @_;
	my $n = int((@$set-1)/2);
	my $diff = Lib::sum(@{$set}[0..$n]) - Lib::sum(@{$set}[$#$set-$n+1..$#$set]);
	#print "Diff is $diff\n";
	return $diff > 0 ? 1 : 0;
}

my $n = 7;
my @attempt = (1..$n);
my $minsum = 1000000000000;
my $best;
attempt: while(1) {
	last;
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
	$tests = 0;
	print "@attempt; test = ".test1(\@attempt)."\n";
	print "Tests: $tests\n";
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
				print "@attempt[@test] failed1\n";
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
					print "@attempt[@test] failed2 (@$order)\n";
					$attempt[$test[5]]++;
					for($test[5]+1..$n-1) {
						$attempt[$_] = $attempt[$_-1]+1;
					}
					next attempt;
				}
			}
		}
	}
	print "Success\n";
	if ($sum < $minsum) {
		$best = join('',@attempt);
		$minsum = $sum;
	}
	$attempt[$n-1]++;
}
print "$best\n";
my $sum = 0;
open SETS, "sets.txt";
while($_ = <SETS>) {
	$_ =~ s/\s+//s;
	my @set = sort { $a <=> $b } split /,/, $_;
	my $res = test2(\@set);
	print "Set: @set; result2: $res\n";
	next unless $res;
	$res = test1(\@set);
	print "Set: @set; result1: $res\n";
	next unless $res;
	$sum += Lib::sum(@set);
}
print "$sum\n";
