# This one looks like an application of testing the decimal places of floats.
# The number of derangements D(n).
#
# Number of permutations is 100!.
# Number fixing 3 primes is 25C3 times number fixing 1, 2, 3.
# Number fixing 1,2,3 and deranging 4..25 is sum_n=22^100 D(n)
#
# Answer is 25C3 * sum(...) / 100!.
#
# Let's investigate D(n).
# Take a derangement in D(n-1), expressed in disjoint cycle notation. Stick n
# after a random point in any cycle. The result is in D(n).
# Take a derangement in D(n-2). Pick a random point and shift all subsequent
# values up, then compose a transposition. The result is in D(n).
# These are 1-1, so D(n) = (n-1)(D(n-1)+D(n-2)).
#
# Let the bigints roll.

use Math::BigInt;
my $total = 100;
my $block = 25;
my $fixed = 3;

my $fac = Math::BigInt->new($total);
$fac->bfac();

my @derange = (Math::BigInt->new(1), Math::BigInt->new(0));
for(2..$total-$fixed) {
	$derange[$_] = ($_-1) * ($derange[$_-1] + $derange[$_-2]);
}

my $sum = Math::BigInt->new(0);
my $ncr = Math::BigInt->new(1); # (b-t)C(_-t)
for(reverse $block-$fixed..$total-$fixed) {
	$sum += $ncr * $derange[$_];
	$ncr *= $_ - ($block-$fixed);
	$ncr /= (($total-$fixed) - $_ + 1);
}

my $ncr2 = Math::BigInt->new($block)->bfac() / (Math::BigInt->new($block-$fixed)->bfac() * Math::BigInt->new($fixed)->bfac());
$sum *= $ncr2;

use Lib::NumberTheory;
my $g = Lib::gcd($fac,$sum);

my $sum12 = $sum * 10**12;
$sum12 /= $fac;
#printf ("%s/%s=0.%012i\n", $sum/$g, $fac/$g, $sum12);
printf ("0.%012i\n", $sum12);
