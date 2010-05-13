# If n=x^2+qy^2 let g=gcd(x,y). If g>1 then g^2|n so n=(gx')^2+q(gy')^2.
# Thus for each property there exists a "primitivity" concept - those n whose
# x and y are coprime.

# Suppose n is representable as x^2+qy^2 and gcd(x,y)=1, and p|n. p divides
# neither x nor y so x^2+qy^2=0 mod p and neither term is zero mod p.
# Thus (xy^-1)^2 = -q mod p, and the quadratic residue symbol (-q/p) = +1.
# If p=4k+1, (-q/p) = (-q)^((p-1)/2) mod p = q^((p-1)/2) mod p and so
# q^(2k)=1 mod p.
# If p=4k+3, q^(2k+1) = -1 mod p.

# Now suppose -q=r^2 is a perfect square mod p.
# Showing p is a sum of squares as required means (ry)^2=x^2 mod p
# Let s = sqrt(p/q).
# Pick a,b such that |-r/p-a/b| < 1/(bs) and 0<b<s (these exist
# using continued fractions).
# Let c=rb+pa=rb mod p (top line in the modulus). |c| < pb/(bs) = sqrt(p)
# and so 0 < qb^2+c^2 < (q+1)p

# The first perfect square criteria need not be checked.

# For the remainder, we write n'=m^2n where n has no prime factors of form
# 4k+1 so that we must now be able to use a primitive rep.
# (x^2+qy^2)(z^2+qw^2)=(xz)^2+q((yz)^2+(xw)^2)+q^2(yw)^2
# =(xz+qyw)^2+q(yz-xw)^2
# Thus being a square sum like this is multiplicative.

# Get some primes.
use Lib::NumberTheory;
use Lib::IncrementList;
use Lib::Utils;
use strict;
use warnings;
my $target = 10**7;
my @primes = Lib::flatten Lib::hclip { $_ * $_ < $target } Lib::primes;
my @fourk1 = grep { $_ % 4 == 1 } @primes;
my @notprimitive;
my @primitive;
my $i = 0;
for my $p (@primes) {
	my $ok = 1;
	for my $q (1, 2, 3, 7) {
		my $a = Lib::binary_power_mod($q, ($p-1)/2, $p);
		if ($p % 4 == 1) {
			$ok &&= $a != 1;
		} else {
			$ok &&= $a != $p-1;
		}
		last unless $ok;
	}
	if ($ok) {
		push @primitive, $p;
	} else {
		push @notprimitive, $p;
	}
}
# All primes in @notprimitive must only appear as squares.
print "@primitive\n";

my $factors = Lib::lists
	Lib::incrementor_short_lex(),
	Lib::initialiser_strictly_increasing(0),
	sub {
		return if $_[1][$#{$_[1]}] > $#primitive;
		my $p = Lib::product(@primitive[@{$_[1]}]);
		return $p < $target
	},
	();
my $count = 0;
while(my $f = $factors->()) {
	last unless $f;
	my $factor = Lib::product(@primitive[@$f]);
	$count++; #= int(sqrt($target/$factor));
}
print "$count\n";
