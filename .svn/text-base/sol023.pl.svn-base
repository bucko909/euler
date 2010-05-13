# Generate the divisors in bulk, sum them and use that to find the abundants.
# Then check if a number is a sum of abundants by subrtracting each abundant
# from it, then checking if the result is abundant.
use Lib;
my $max = 28123;
my @divisors = Lib::alldivisors($max);
my @sumdivisors = map { my @a = @$_; Lib::sum(@a) } @divisors;

# A list of abundants.
my @abundant = grep { $_ < $sumdivisors[$_] } 1..$max;

# Use to check if an number is abundant.
my @abcheck;
$abcheck[$_] = 1 for(@abundant);

my $sum = 0;
for my $n (1..$max) {
	my $absum = 0;
	for my $ab (@abundant) {
		if ($ab > $n) {
			last;
		} elsif (defined $abcheck[$n-$ab]) {
			$absum = 1;
			last;
		}
	}
	$sum += $n unless $absum;
}
print "$sum\n";
