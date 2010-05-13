# I thought about this problem for a long time. There are a number of ways of
# generating "sets which need to be checked", but I couldn't find one which
# worked uniquely. This is mostly because I did some terrible maths and worked
# out that 7C4 is 42, not 35, so I was trying to kill 7 more sets.
#
# Here follows my analysis for the problem.
#
# Represent a choice of A and B as a string in {A,B,.}^*. so that AB.BA means
# A = {a[0], a[4]} and B = {a[1], a[3]}
#
# Start by picking a full subset of size 2n. Pick two "holes". Now for each
# valid string for subsets of size n-1 which don't hit the holes, add the
# holes back in with the larger hole in the set with the smaller sum. Always
# assume A has the smallest element. There is never a need to check a pair
# where every element of one set is greater than the corresponding element of
# the other.
#
# This gives us the step from 2 to 3:
# 2: ABBA
# 3: A..BBA, A.B.BA, A.BB.A, A.BBA., AB..BA, AB.B.A, AB.BA., ABB..A, ABB.A.,
# ABBA..
#
# It turns out that most of these result in duplicates. For instance, A..BBA, if
# it needs to be checked, can be generated from A.B.BA, A.BB.A, AB..BA or AB.B.A
#
# Overall for a set of size 6 there are 5 patterns.
# ABBBAA, ABBABA, ABBAAB, ABABBA, AABBBA
#
# and once ..ABBA is checked we can tell which of ABABBA and ABBAAB we need to
# look at. These are the only two "invertible pairs" as such, and it happens
# that if drawing a graph of the strings by single, adjacent transpositions,
# graded by number of transpositions from ABBBAA this occurs at a branch point
# I theorised that this could in general be extended, to no avail so that at any
# such branch point only one branch would ever need to be checked.
#
# ABBBAA -> ABBABA -> ABABBA -> AABBBA ->(AABBAB)
#                 _\|       _\|
#                     ABBAAB ->(ABABAB)
#
# Once a bad point is hit there is no return as we only increase the sum of B
# and decrease the sum of A - and everything in B is already bigger than its
# corresponding thing in A.
#
# Note that such a branch point is always of the form BA.*BA where the branch
# corresponds to swapping each choice of BA, giving AB.*BA or BA.*AB. We
# therefore really only need to follow one branch if we have tested all subsets
# of size 2. Now, the solution is to find the longest string and multiply by
# kC2n.
#
# For n = 7, we have 7C6 * 4 + 7C3 * 1 = 7*4 + 7*5*1 = 70 as required
# (what awesome maths I have there.)
#
#
# Of course, the correct solution is not the depth of the tree but the number
# of elements in it. It's easily calculable using Catalan numbers as it
# corresponds to invalid nested brackets. I don't use that here.

my @cache;
# Takes a maximum value (ie. overall set size), and a sequence which represents
# which indices in the array we with to assign to the second set.
# Calculate using depth(2n-1, 1, 2, ..., n)
# (We may as well assume the 0th element is in the first set.)
sub depth {
	my $cname = "@_";
	return 0 if defined $cache{$cname};
	my ($maxelt, @vals) = @_;
	my $counter = $vals[0]-1;
	for(1..$#vals) {
		$counter += $vals[$_] - $vals[$_-1] - 2;
		if ($counter < 0) {
			last;
		}
	}
	return $cache{$cname} = 0 if $counter >= 0;
	# Find possible ways of moving a set right.
	my $sum = 0;
	my $max = 0;
	for(0..$#vals) {
		if ($_ < $#vals && $vals[$_] + 1 < $vals[$_ + 1]) {
			local $vals[$_] = $vals[$_] + 1;
			my $res = depth($maxelt, @vals);
			$max = $res if $res > $max;
			$sum += $res;
		} elsif ($_ == $#vals && $vals[$_] < $maxelt) {
			local $vals[$_] = $vals[$_] + 1;
			my $res = depth($maxelt, @vals);
			$max = $res if $res > $max;
			$sum += $res;
		}
	}
	return $cache{$cname} = $sum+1;
}

sub fac {
	return 1 if $_[0] < 2;
	return $_[0] * fac($_[0] - 1);
}

sub ncr {
	return fac($_[0]) / (fac($_[1]) * fac($_[0] - $_[1]));
}

my $sum = 0;
my $n = 12;
my $max = int($n/2);
for(2..$max) {
	my $depth = depth(2*$_-1, 1..$_)."\n";
	$sum += ncr($n, 2*$_) * $depth;
}
print "$sum\n";
