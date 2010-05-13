# A recursive solution.
use Lib;
my @cache;
sub calc {
	my $target = $_[0]; # Target to sum to
	my $limit = $_[1]; # Highest number allowed in sum.
	$limit = $target if $limit > $target;
	return $cache[$target][$limit] if $cache[$target][$limit];
	if ($limit == 1) {
		# 1 + 1 + ... -- only 1 way
		return 1;
	} elsif ($limit == 2) {
		# There's 1 + 1 + ..., and all the multiples of 2.
		return int($target/2)+1;
	} else {
		# $l iterates numbers less than the limit.
		# For all possibilities for number of $l in the sum, remove them, then
		# compute the ways of making $target - $l * $_ using only numbers up
		# to $l - 1.
		my $sum = 1;
		for my $l (2..$limit) {
			for(1..int(($target)/$l)) {
				$sum += calc($target - $l*$_, $l-1);
			}
		}
		return $cache[$target][$limit] = $sum;
	}
}
my $sum = calc(100, 99);
print "$sum\n";
