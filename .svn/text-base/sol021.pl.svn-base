# Generate the divisors in bulk, sum them and then grep for amicalble pairs.
use Lib;
my $max = 10000;
my @divisors = Lib::alldivisors($max);
my @sumdivisors = map { my @a = @$_; Lib::sum(@a) } @divisors;
my @amicable = grep {
	   $_ == $sumdivisors[$sumdivisors[$_]]
	&& $_ != $sumdivisors[$_]
} 1..$max;
print Lib::sum(@amicable)."\n";
