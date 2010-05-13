# Numbers much lower than 72, so we can happily count directly this time.
# Slight optimisation(?) is that rather than compute GCD for each, just check
# if they can be divided by any prime factor.
use Lib;
my $target = 10000;
my @primes = ();
open P, "primes 1 $target|";
while(<P>) {
	chomp;
	push @primes, $_;
}
close P;

my @exponents = (0);
$sum = 0; # (0) only has 1/2, which isn't < 1/2.
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
		$v;
	} \@exponents;
	last unless defined $value;
	# $value is denominator.
	# Work out the range of numerators to search.
	my $first = int($value/3)+1;
	my $last = int($value/2);
	$last-- if $value % 2 == 0;
	outer:for(my $n=$first; $n <= $last; $n++) {
		for(@exponents) {
			next outer if $n % $primes[$_] == 0;
		}
		$sum++;
	}
}
print "$sum\n";
