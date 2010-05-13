# A recursive solution.
use Lib;
my @cache;
my @primes = Lib::flatten Lib::htake 1000, Lib::primes;
sub calc {
	my $target = $_[0]; # Target to sum to
	my $limit = $_[1]; # Highest number allowed in sum.
	$limit = $target if $limit > $target;
	return $cache[$target][$limit] if $cache[$target][$limit];
	if ($limit == 0) {
		# There's 2 + 2 + ... only
		return ($target+1)%2;
	} else {
		# $l iterates numbers less than the limit.
		# For all possibilities for number of $l in the sum, remove them, then
		# compute the ways of making $target - $l * $_ using only numbers up
		# to $l - 1.
		my $sum = ($target+1)%2;
		for my $l (1..$limit) {
			for(1..int($target/$primes[$l])) {
				$sum += calc($target - $_*$primes[$l], $l-1);
			}
		}
		return $cache[$target][$limit] = $sum;
	}
}
for($i=0;calc($i,$i)<5000;$i++) {}
print "$i\n";
