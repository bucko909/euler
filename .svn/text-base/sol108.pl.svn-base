# 1/x + 1/y = 1/n
#
# We must have x > n, so let x = n + l. We have 1/n - 1/x = (x-n)/(nx).
# But then x - n = l divides nx = n(n+l).
# l divides ln, so this is true iff l divides n^2.
# Thus, the number of solutions solutions is the number of l that divide n^2.
# Suppose x <= y, then x <= 2n, so l <= n, and this is how to find the number
# of pairs of solutions as required.
#
# Note that if l divides n^2, then n^2/l divides n^2, too. Thus, excepting n,
# precicesly half of the divisors lie below n.
#
# This means the solution will be realised when we have a decreasing set of
# prime powers (if we have p^2 and only q^1 woth p>q, swap q and p and get at
# least as many solutions but a lower product).
#
# We can see this in the example 1260 for P110; 1260 = 2^2 * 3^2 * 5 * 7
#
# Additionally, if we have p^j and q^l with q > p, then let i >= (2j+1)/(2l-1)
# if p^i < q then we can use p^{j+i}q^{i-1} instead of p^j q^i, so we must have
# q < p^i.
#
# Similarly, let i <= (2a+1)/(2l+3) and we can replace with p^{j-i}q^{l+1}.
# So one had better hope that q > p^i.
use Lib;
use warnings;
use strict;
my $target = 1000;
my @primes = ();
open P, "primes 1 4000|";
while(<P>) {
	chomp;
	push @primes, $_;
}
close P;

my @prime_powers = ();
my $min;
my $lastlen;
while(1) {
	$lastlen = @prime_powers;
	my $value = Lib::listinc_shortlex {
		my $p = $_[0];
		# Check it's decreasing.
		for(1..$#$p) {
			return if $p->[$_-1] < $p->[$_];
		}
		# Check the initial powers are about right.
		# This one messes up counting...
		#for my $first (0..$#$p-1) {
		#	for my $second ($first+1..$#$p) {
		#		my $power = $p->[$second]||0;
		#		my $lowerval = (2*$p->[$first]+1)/(2*$power-1);
		#		$lowerval = int $lowerval + ($lowerval > int $lowerval ? 1 : 0);
		#		if ($primes[$second] >= $primes[$first]**$lowerval) {
		#			return;
		#		}
		#	}
		#}
		for my $first (0..$#$p) {
			for my $second ($first+1..$#$p+1) {
				my $power = $p->[$second]||0;
				my $upperval = int((2*$p->[$first]+1)/(2*$power+3));
				if ($primes[$second] <= $primes[$first]**$upperval) {
					return;
				}
			}
		}

		# Count the factors of n.
		my $count = ((Lib::product map { 2*$_ + 1 } @$p) + 1)/2;
		return $count;
	} \@prime_powers, sub {
		my ($last, $this) = @_;
		# Pick the minimum "large enough" value for each entry.
		# Need p_i^{2a+1} >= p_n
		# So (2a+1) log p_i >= log p_n
		# So 2a+1 >= log p_n/log p_i
		# So a >= (log p_n-1)/2log p_i
		my $i = (log($primes[$last])-1)/2/log($primes[$this]);
		$i = 1 if $i < 1;
		if ($i - int($i) > 0) {
			$i = int($i)+1;
		} else {
			$i = int($i);
		}
		return $i;
	};
	last unless defined $value;
	my $n = Lib::product map { $primes[$_] ** $prime_powers[$_] } 0..$#prime_powers;
	next if $value < $target;
	if (!$min || $min > $n) {
		$min = $n;
	}
	if ($lastlen < @prime_powers) {
		last;
	}
}
print "$min\n";
