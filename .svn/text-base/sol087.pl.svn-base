# This one's simple. Just run through all primes up to the square root of
# the target, then all primes up to the cube root of the remainder, then all
# primes up to the 4th root of that. There's only 908 primes under the root,
# so...
use Lib;
my $target = 50000000;
my $maxprime = int(sqrt($target));
my @primes = Lib::flatten Lib::hclip { $_ <= $maxprime } Lib::primes;
my $count = 0;
for(my $tosquare = 0; $tosquare < @primes; $tosquare++) {
	my $val1 = $primes[$tosquare]**2;
	my $pmax1 = int(($target - $val1)**(1/3));
	for(my $tocube = 0; $primes[$tocube] <= $pmax1; $tocube++) {
		my $val2 = $val1 + $primes[$tocube]**3;
		my $pmax2 = int(($target - $val2)**(1/4));
		for(my $to4 = 0; $primes[$to4] <= $pmax2; $to4++) {
			my $val = $val2 + $primes[$to4]**4;
			if (!$hit[$val]) {
				$hit[$val] = 1;
				$count++;
			}
		}
	}
}
print "$count\n";
