# Decreasing, corresponds to a choice of exactly 9 bars in between the digits
# where the numbers decrease. They can be in adjacent. For example,
# 9985540 -> 99|8|||55|4||||0.
# 743 -> ||7|||4|3|||.
#
# The number of ways of putting k bars in a number of length 9 is
# (n+9)C9
#
# Increasing numbers are the same, but you only insert 8 bars (0 is never
# present in an increasing number.)
#
# Numbers which are constant fit both of these, so we must remove 10 from inc
# (it includes 000000000).
#
# The answer, then, is the sum of these. It looks like Perl is happy enough
# with the bignums; if not an optimised ncr might be useful.

my @fac = (1, 1);
sub fac {
	my $n = $_[0];
	return $fac[$n] if defined $fac[$n];
	return $fac[$n] = fac($n - 1) * $n;
}

sub ncr {
	my ($n, $r) = @_;
	return fac($n) / (fac($r) * fac($n - $r));
}

my $sum = 0;
for(1..100) {
	my $inc = ncr($_ + 9, 9);
	my $dec = ncr($_ + 8, 8);
	my $const = 10;
	$sum += $inc + $dec - $const;
}
print "$sum\n";
