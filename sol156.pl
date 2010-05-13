#!/usr/bin/perl

use strict;
use warnings;

# First thing to notice is that f can be computed rather quickly by
# by grinding through digits. The natural method is recursive, but it's
# only tail recursion, so we can use a loop!

sub f {
	my ($n,$d) = @_;
	my $p = length $n;
	my $t = 0;
	while ($p) {
		$p--;
		my $l = int($n/10**$p);
		$n = $n % 10**$p;
		my $a;
		if ($l < $d) {
			$a = $l * $p * 10**($p-1);
		} elsif ($l > $d) {
			$a = ($l * $p + 10) * 10**($p-1);
		} else {
			$a = $l * $p * 10**($p-1) + $n + 1;
		}
		$t += $a;
	}
	return $t;
}

# Next observation is that f(10**n,d) = d*10**(n-1) which means there are no
# solutions n where n>10**11 (with a bit of work).

# We now need two types of routine: Find where f(n,d)>=n next and find where
# f(n,d)<=n next.

# If f(n,d)>n, find the first instance of d in n, and replace with d+1 (doing
# sensible stuff for d=9). Replace everything after with zeros. Any number
# below this new n' has f(i,d)>i so we can ignore. We are able to guarantee
# that there /is/ a $d in the number.
#
# So we have a number of the form a1 a2 ... an with no ai = d and the trailing
# bits equal to 0. Try incrementing the first nonzero digit to get a number m.
# If f(m,d)<=m then move right a digit and try again. If not, increment again,
# possibly moving left a digit and removing instances of d again if it gets
# too high.

sub find_lower {
	my ($n, $d) = @_;
	
	my @n = split //, $n;
	my $i = -1;

	# Remove everything after the first $d.
	while(++$i <= $#n) {
		if ($n[$i] == $d) {
			@n[$i+1..$#n] = ((0) x ($#n-$i));
			last;
		}
	}

	# The number is now always zero after digit $i
	my $earliestfoundspot;
	my $first = 1;
	while(@n <= 11 && $i <= $#n) {
		my @on = @n;
		my $oi = $i;
		$i = increment_and_remove_d(\@n, $d, $i, $first);
		undef $first;
		$n = 0;
		$n = $n*10+$_ for @n;

		my $f = f($n, $d);
		# Second condition catches edge case where sometimes (eg. at 60000000000) we
		# 'just miss' a repeat. This probably implies the code is bad; a better solution
		# would be to notice that if $d > 1 and $n is a solution then so is $i $n for each
		# $i < $d.
		if ($f < $n || $f == $n + 1) {
			# Overshot. $i < $n always
			@n = @on;
			$i = $oi + 1;
		} elsif ($f > $n) {
			# Undershot. Leave as-is and we'll increment again on next loop.
		} else {
			# Spot on. If $i==$#n, it's the smallest. If not, we must try some
			# smaller candidates just to make sure.
			$earliestfoundspot = $n;
			last if ($i == $#n);
			@n = @on;
			$i = $oi + 1;
		}
	}
	return $earliestfoundspot;
}

sub increment_and_remove_d {
	my ($n, $d, $i, $first) = @_;
	while($i>=0) {
		$n->[$i]++;
		if ($n->[$i] == 10) {
			$n->[$i] = 0;
			$i--;
			#} elsif ($n->[$i] == $d) {
			# Just reloop
		} else {
			last;
		}
	}
	if ($i == -1) {
		if (0 && $first) {
			unshift @$n, $d == 9 ? 1 : $d + 1;
		} else {
			unshift @$n, $d == 1 ? 2 : 1;
		}
		$i = 0;
	}
	return $i;
}

# Now we need to be able to find the next instance from below; in this case we
# may assume that no digit in $n is $d. Obviously we are going to need /two/
# digits equal to $d to catch back up, and we may as well assume one of them
# is at the end. We must search numbers of form: blah $d blah2 $d
#
# Since no digits are equal to $d, and $d>0 we can't just increment into this
# situation, so blah2 is nonempty. First try $i=blah $d 9999 $d.
# If f($i,$d) >= $i then try decrementing digits from the left until it's not.
# If f($i,$d) <  $i then add a 9 and repeat. Possibly lengthen $i.

sub find_higher {
	my ($n, $d) = @_;
	
	my @n = split //, $n;
	my $i;
	if (@n < 3) {
		$i = 1;
		@n = ($d, 9, $d);
	} else {
		$i = $#n-1;
		$n[$#n] = $n[$#n-2] = $d;
		$n[$#n-1] = 9;
	}

	# Keep bunging in 9s until it's big!
	a:while($i <= $#n) {
		$n = 0;
		$n = $n*10+$_ for @n;

		if (f($n, $d) < $n) {
			# Undershot.
			# Make sure we don't end up decreasing the number by growing the 9
			# region.
			while($i > 1 && $n[$i-2] > $d) {
				if ($n[$i-2] < 9) {
					# Need to increment
					$n[$i-2]++;
					next a;
				} else {
					# Nom nom nom
					$i--;
					$n[$i] = 9;
					$n[$i-1] = $d;
				}
			}
			if ($i == 1) {
				# Need to lengthen
				unshift @n, $d;
				return if @n > 11;
				$n[1] = 9;
			} else {
				# Need to grow the '9' region
				$i--;
				$n[$i] = 9;
				$n[$i-1] = $d;
			}
		} else {
			last;
		}
	}

	# Now the number is blah $d 9999 $d. We want the lowest replacement for
	# 999 such that f($n,$d) >= $n.
	$n[$_]=0 for($i..$#n);
	my $best = $n;
	while($i <= $#n) {
		$n[$i]++;
		$n = 0;
		$n = $n*10+$_ for @n;

		if (f($n, $d) >= $n) {
			# Went too far?
			$best = $n if $best > $n;
			$n[$i]--;
			$i++;
		} elsif ($n[$i] == 9) {
			$i++;
		}
	}
	return $best;
}

# Now we just need to wander up and down until we're done!
sub s {
	my ($d) = @_;
	my $n = 0;
	my $t = 0;
	while($n < 10**11) {
		my $f = f($n, $d);
		if ($f == $n) {
			$t += $n;
			$n++;
		} elsif ($f < $n) {
			$n = find_higher($n, $d);
		} else {
			$n = find_lower($n, $d);
		}
		last unless $n;
	}
	return $t;
}

my $t = 0;
$t += &s($_) for 1..9;

print "$t\n";
