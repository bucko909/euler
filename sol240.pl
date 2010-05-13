# First work out the ways to make 70 out of 10 rolls. Take the minimum roll, 
# say i, and let l be the number of rolls of value >i. Then we are concerned
# with unordered partitions of 20-l of length i.
#
# So, for each top 10, with min i, and l are >i, ways is:
# sum multinomial(l+k,counts top l,k) * 20C(20-l-k) * (i-1)^(20-k-l)
#
# range(k) = {20-l} if i=1
# range(k) = {10-l,...,20-l} if i>1
#
# For the problem, there's about 9000 top 10 rolls, and a max range of
# about 15 for k - that's an acceptably small count.
use strict;
use warnings;

my $topn = 10;
my $total = 20;
my $toptot = 70;
my $maxroll = 12;

# Generate some of Pascal's triangle.
our @ncr = ([1], [1, 1, 0]);
for my $n (2..$total) {
	$ncr[$n][0] = 1;
	$ncr[$n][$_] = $ncr[$n-1][$_-1] + $ncr[$n-1][$_] for 1..$n;
	$ncr[$n][$n+1] = 0;
}

sub enumerate {
	my ($t, $max, $remain, @sofar) = @_;
	if ($remain > 1) {
		my $min = $t/$remain;
		$min = int $min + 1 if $min != int $min;
		$max = $t - $remain + 1 if $max > $t - $remain + 1;
		my $tot = 0;
		for ($min..$max) {
			$tot += enumerate($t-$_, $_, $remain - 1, @sofar, $_);
		}
		return $tot;
	} else {
		# $max is the lowest in the chain.
		push @sofar, $t;
		$max = $t;
		my $multi = 1;
		my $count = 0;
		my $last = 0;
		my $thiscount = 0;
		for(@sofar) {
			if ($_ != $last) {
				$multi *= $ncr[$count][$thiscount];
				$last = $_;
				$thiscount = 0;
			}
			last if $_ == $max;
			$thiscount++;
			$count++;
		}
		if ($max == 1) {
			return $multi * $ncr[$total][$count];
			# Rest is 11111111 so no combinations.
		} else {
			my $sum = 0;
			for my $k ($topn-$count..$total-$count) {
				my $multi2 = $multi * $ncr[$count+$k][$k];
				my $bin = $ncr[$total][$k+$count];
				$sum += $multi2 * $bin * ($max-1)**($total-$k-$count);
			}
			return $sum;
		}
	}
}

my $ans = enumerate($toptot,$maxroll,$topn);
print "$ans\n";


