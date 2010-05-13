# Number of proper fractions with denominator n is just phi(n).
# So we need to compute the phi function for all numbers less than a million
# and output the sum.
use Lib;
my $target = 1000000;
my @primes = ();
open P, "primes 1 1000000|";
while(<P>) {
	chomp;
	push @primes, $_;
}
close P;

my @exponents = (0);
$sum = 1; # (0) hardcoded.
while(1) {
	my $value = Lib::listinc_lex_increasing {
		# We regard the end of the list as always being one more than stated.
		# If the list is long and has 0 in the 2nd and 3rd place, disregard.
		# Calculate the product of all the primes.
		my $v = Lib::product map {
			$primes[$_]
		} (@{$_[0]});
		# If it's too big, drop out. If it's one element long, return 0.
		# That's a special case to allow incrementing the first bit.
		return if @{$_[0]} == 0 || $_[0][0] >= @primes || $v > $target;
		my $last = -1;
		for(my $i=0; $i<@{$_[0]}; $i++) {
			if (!defined $_[0][$i+1] || $_[0][$i] != $_[0][$i+1]) {
				$v *= (1 - 1/$primes[$_[0][$i]]);
			}
		}
		$v;
	} \@exponents;
	last unless defined $value;
	$sum += $value;
}
print "$sum\n";
