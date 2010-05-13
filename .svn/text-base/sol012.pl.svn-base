# Note that if d is divisors, d(n(n+1)/2) = d(n)*d((n+1)/2) (or the other way
# around).

use Lib;
my $i;
my @d_cache;
my $max_d = 0;
for($i=1; ;$i++) {
	my ($div, $not) = $i % 2 ? ($i + 1, $i) : ($i, $i + 1);
	my $divisors = ($d_cache[$div/2] ||= Lib::divisors($div/2)) *
		($d_cache[$not] ||= Lib::divisors($not));
	last if $divisors >= 500;
}
my $ans = $i * ($i + 1) / 2;
print "$ans\n";
