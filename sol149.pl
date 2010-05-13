# To find the maximal continuous sum note that you can just run along the
# set, summing. If you go below zero reset the start, else there's no
# disadvantage to keeping the current initial segment.
#
# The code takes 5 seconds to generate the initial table, then a further 10
# seconds to do the search. Of this, about 1.5s is the first lot, 3s for each
# of the rest. It seems unlikely this can be improved in Perl.

use strict;
use warnings;

sub max_sum {
	my $sum = 0;
	my $max = 0;
	for(my $end=0; $end<@_; $end++) {
		$sum += $_[$end];
		if ($sum < 0) {
			$sum = 0;
		} elsif ($sum > $max) {
			$max = $sum;
		}
	}
	$max
}

my @arr;
sub myrand {
	if (@arr < 55) {
		my $k = @arr+1;
		push @arr, (100003 - 200003*$k + 300007*$k*$k*$k) % 1000000 - 500000;
	} else {
		push @arr, ($arr[0] + $arr[31] + 1000000) % 1000000 - 500000;
		shift @arr;
	}
	$arr[$#arr];
}

my $size = 1999;
my @grid; # = ([-1,8,-4,8],[3,2,7,3],[9,-6,5,1],[-2,5,3,2]);
for(0..$size) {
	my @row;
	for(0..$size) {
		push @row, myrand();
	}
	push @grid, \@row;
}

my $max = 0;
# rows
for(0..$size) {
	my $val = max_sum(@{$grid[$_]});
	$max = $val if $max < $val;
}
for my $col (0..$size) {
	my $val = max_sum(map { $grid[$_][$col] } 0..$size);
	$max = $val if $max < $val;
}
for my $sum (0..2*$size) {
	my $start = $sum - $size;
	$start = 0 if $start < 0;
	my $end = $sum;
	$end = $size if $end > $size;
	my @bit = map { $grid[$_][$sum-$_] } $start..$end;
	my $val = max_sum(@bit);
	$max = $val if $max < $val;
	@bit = map { $grid[$size-$_][$sum-$_] } $start..$end;
	$val = max_sum(@bit);
	$max = $val if $max < $val;
}
print "$max\n";
