# Note that:
# n is even, so n^2=(2m)^2=4m^2
# The next two eliminate multiples of 3 and 7.
# Also 13.
#
# First thought: Make a seive of residues over the first few primes, and test
# only those n such that n^2 looks to be about right in the seive.
# This makes either too large a seive or too many candidates (up to 19, the
# seive is about 500K elements for the purposes of 10K residues).
#
# Need n^2 + s mod p != 0 for all s and all p<=sqrt(n^2+s)
# mod 2, this gives n = 0, mod 2.
# mod 3, this gives n = 1 or 2, mod 3. (so n=2, n=4 mod 6)
# mod 5, this gives n = 0, mod 5 (so n=10, n=20 mod 30)
# mod 7, this gives n in {3, 4}, mod 7 (so n=10, n=80, n=130, n=200 mod 210)
# mod 11, this gives n in {0, 1, 4, 5, 6, 7, 10}, mod 11
#
# Solve modulo primes until the count is pretty small, then do primality
# testing on the results.
#
# TODO this code is /slow/ (2m9s) because prime() takes a long time. Some faster
# methods of primality testing may be useful.


use Lib::NumberTheory;
use Lib::Utils;
use Math::BigInt;
my $max = 150000000;
my @cand = (0);
my $prod = 1;
my @stat = (1,3,7,9,13,27);
my @stest;
$stest[$_] = 1 for @stat;
my $maxp = $max; # 10^2 so as not to nom 10.
my $c=0;
my @sol;
my @used_primes;
# My prime generator is nowhere near fast enough, so let's cheat a bit.
my $max_prime = int(sqrt($max*$max+$stat[$#stat]));
my @primes;
open PRIMES, "primes 1 $max_prime|";
while(<PRIMES>) {
	chomp;
	push @primes, int($_);
}
close PRIMES;

for my $p (@primes) {
	my $count = 0;

	# Pull out anything that's now (probably) a solution.
	push @sol, $cand[0] if $cand[0]*$cand[0]+1 == $p;

	my @new;
	if ($prod < $max) {
		# Cache the bad values of n^2 mod p.
		my @t = map { (-$_) % $p } @stat;
		my @test;
		$test[$_] = 1 for @t;

		# map (mod-cand)%p -> mul, so that modular sols don't need solving all
		# the time later. For each i, sols[i]*prod=i mod p
		my $prodmod = 1;
		$prodmod = ($prodmod * $_) % $p for @used_primes;
		my @sols;
		$sols[($prodmod*$_)%$p] = $_ for 0..$p-1;

		for $mod (0..$p-1) {
			my $m2 = ($mod*$mod) % $p;
			next if $test[$m2];
			for my $cand (@cand) {
				# Since we know $mod is a 'good' modulo, we need to find the
				# value of mul<p such that mul*prod+cand=mod, sol sols[mod-cand]
				my $mul = $sols[($mod - $cand) % $p];
				push @new, $prod * $mul + $cand if $prod * $mul + $cand <= $max;
			}
		}
		@new = sort @new;
		push @used_primes, $p;
		$prod *= $p;
		$prod = $max if $prod > $max;
	} else {
		# We know mul above must be 0, which is only a solution for mod=cand
		for my $cand (@cand) {
			my $m2 = (-$cand*$cand) % $p;
			next if $stest[$m2];
			push @new, $cand;
		}
	}
	@cand = @new;
	last if $prod == $max && @cand < 25;
}

# At this point @cand has <1000 candidate values of n. Add back on the
# "solutions" that were already found.
@cand = sort { $a <=> $b } (@sol, @cand);

# Now factor the buggers.
my $sum = 0;
n: for my $n (@cand) {
	my $v = $n*$n;
	my $os = -1;
	for (@stat) {
		my $not_prime = $_ - $os - 1;
		$os = $_;
		for(1..$not_prime) {
			next n if prime($v);
			$v++;
		}
		$v++;
	}
	$v = $n*$n;
	for (@stat) {
		next n if !prime($v+$_);
	}
	$sum += $n;
}
print "$sum\n";

sub prime {
	my $n = $_[0];
	my $max = int(sqrt($n));
	for(@primes) {
		return 1 if $_ > $max;
		return 0 if $n % $_ == 0;
	}
}
