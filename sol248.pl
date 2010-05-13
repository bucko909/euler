# Involves checking primality of some pretty large numbers, in theory.

use strict;
use warnings;
use Lib::IncrementList;
use Lib::Lists;
use Lib::NumberTheory;

# First, factorise 13!.
my @smallprimes = (2,3,5,7,11,13);
my @fac_coef = ((0) x 6);
for my $num (2..13) {
	for(0..$#smallprimes) {
		while ($num % $smallprimes[$_] == 0) {
			$num /= $smallprimes[$_];
			$fac_coef[$_]++;
		}
	}
}

# Now generate all of its factors.
my $runover = Lib::lists Lib::incrementor_short_lex(), sub { 0 }, sub { return if @{$_[1]} > @fac_coef; return if $_[1][$_[0]] > $fac_coef[$_[0]]; return 1 }, ((0) x @fac_coef);
my @facs;
my %bd;
while(my $l = $runover->()) {
	my $v = 1;
	$v *= $smallprimes[$_] ** $l->[$_] for 0..$#$l;
	$bd{$v} = [ @$l ];
	push @facs, $v;
}

@facs = sort { $a <=> $b } @facs;

# Get primes for primality testing.
my $maxprime = int(sqrt($facs[$#facs]+1));
my @primes = Lib::flatten Lib::hclip { $_ <= $maxprime } Lib::primes;

# Now, for each factor or 13! we want to know what primes we could plug in
# to p^n-p^{n-1} to get that factor.
my @poss = map { [] } @facs;

# First powers get pretty large, so we'll do those by testing primality
# directly.
num: for my $idx (0..$#facs) {
	my $num = $facs[$idx] + 1;
	my $max = int(sqrt($num));
	for(@primes) {
		last if $_ > $max;
		next num if $num % $_ == 0;
	}
	push @{$poss[$idx]}, [ $num, 1 ];
}

my %fac_h = map { $facs[$_] => $_ } 0..$#facs;

# For subsequent powers, the numbers are less messy.
prime: for my $prime (@primes) {
	my $test = $prime*(1-1/$prime);
	my $power = 1;
	while(($test=$test*$prime) <= $facs[$#facs]) {
		$power++;
		if (exists $fac_h{$test}) {
			push @{$poss[$fac_h{$test}]}, [ $prime, $power ];
		}
	}
}

for(0..$#facs) {
	print "$facs[$_] => ".join(", ", map { "@$_" } @{$poss[$_]})."\n";
}
