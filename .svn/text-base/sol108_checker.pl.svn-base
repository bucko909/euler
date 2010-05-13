# 1/x + 1/y = 1/n
#
# We must have x > n, so let x = n + l. We have 1/n - 1/x = (x-n)/(nx).
# But then x - n = l divides nx = n(n+l).
# l divides ln, so this is true iff l divides n^2.
# Thus, the number of solutions solutions is the number of l that divide n^2.
# Suppose x <= y, then x <= 2n, so l <= n, and this is how to find the number
# of pairs of solutions as required.

# This means the solution will be realised when we have a decreasing set of
# prime powers (if we have p^2 and only q^1 woth p>q, swap q and p and get at
# least as many solutions but a lower product).
#
# We can see this in the example 1260 for P110; 1260 = 2^2 * 3^2 * 5 * 7
use Lib;
use warnings;
use strict;
my $target = 1000;
my $min;
my @primes = ();
open P, "primes 1 $target|";
while(<P>) {
	chomp;
	push @primes, $_;
}
close P;

my @primes_chosen = ();
while(1) {
	my $value = Lib::listinc_shortlex_increasing {
		# Check we don't skip primes.
		#for(1..$#{$_[0]}) {
		#	return if $_[0][$_] > $_[0][$_-1]+1;
		#}
		my $l = $_[0];
		return if $l->[0] > 0;

		my @p = ();
		my $last = -1;
		my $n = 1;
		for(@$l) {
			if ($last != $_) {
				return if $last < $_ - 1;
				push @p, 1;
			} else {
				$p[$#p]++;
			}
			$last = $_;
			$n *= $primes[$_];
		}

		my $count = 1; # Count the factor 1
		my @primes_testing = ((0) x @p);
		while(1) {
			my $val = Lib::listinc_shortlex {
				return if @{$_[0]} > @p;
				my $prod = 1;
				for (0..$#{$_[0]}) {
					return if $_[0][$_] > 2 * $p[$_];
					$prod *= $primes[$_] ** $_[0][$_];
					return if $prod > $n;
				}
				return 1;
			} \@primes_testing;
			last if @primes_testing > @p;
			$count++;
		}
		return $count;
	} \@primes_chosen, 0;
	last unless defined $value;
	last if @primes_chosen > 9;
	my $n = Lib::product @primes[@primes_chosen];
	my $l = @primes_chosen;
	if ($value >= $target && (!$min || $n < $min)) {
		$min = $n;
	}
}
print "$min\n";
