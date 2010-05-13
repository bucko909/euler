# Some considerations:
# At least one prime power in c must be >1.
#
# Now rad(abc) = rad(c)*rad(ab), so rad(ab) = rad(a) rad(b) < c/rad(c)
# Assume rad a < rad b (ignore a < b) and search a st rad(a) < sqrt(c/rad(c))
# Check gcd(a,c) = 1.
# Now pick b = c - a and check. The gcd condition is automatic.

use Lib::NumberTheory;
use Lib::Lists;
use Lib::IncrementList;
use strict;
use warnings;

my $maxc = 109999;
#my @primes = Lib::flatten Lib::hclip { $_ * $_ < $maxc } Lib::primes;
my @radical = (0, 1);
for my $f (2..$maxc) {
	next if $radical[$f];
	for(my $n = $f*2; $n <= $maxc; $n += $f) {
		$radical[$n] = $radical[$n] ? $radical[$n] * $f : $f;
	}
}
my @primes = grep { !$radical[$_] } (2..$maxc);
for my $f (2..$maxc) {
	$radical[$f] ||= $f;
}
my @radicals = grep { $_ == $radical[$_] } (1..$maxc);
my @sorted;
for(1..$maxc) {
	$sorted[$radical[$_]] ||= [];
	push @{$sorted[$radical[$_]]}, $_;
}
my $cradical_list = Lib::lists
	Lib::incrementor_lex,
	Lib::initialiser_strictly_increasing(0),
	sub {
		   $_[1][$_[0]] < @primes
		&& Lib::product (map { $primes[$_] } @{$_[1]}) < $maxc
		&& $primes[$_[1][0]] ** 2 < $maxc
	},
	(0);
my $sum = 0;
radical:
while(my $cradical_primes = $cradical_list->()) {
	my $cradical = Lib::product map { $primes[$_] } @$cradical_primes;
	my $remain = $maxc / $cradical;
	my $cextra_list = Lib::lists
		Lib::incrementor_short_lex,
		sub { 0 },
		sub {
			   @{$_[1]} <= @$cradical_primes
			&& Lib::product (
			   	map { $primes[$cradical_primes->[$_]]**$_[1][$_] } (0..$#{$_[1]})
			   ) < $remain
		},
		((0) x @$cradical_primes);

	# Compute the list of primes available for a and b.
	my @primes_c = @primes[@$cradical_primes];

	extra:
	while (my $extra_prime_powers = $cextra_list->()) {
		my $cextra = Lib::product (
			   	map { $primes[$cradical_primes->[$_]]**$extra_prime_powers->[$_] } (0..$#$extra_prime_powers)
			);
		next if $cextra == 1;
		my $max_rad_a = sqrt($cextra);
		my $c = $cradical * $cextra;
		my $a;
		a: for my $rad (@radicals) {
			last if $rad > $max_rad_a;
			for my $f (@primes_c) {
				next a if $rad % $f == 0;
			}
			for my $a (@{$sorted[$rad]}) {
				last if $a >= $c;
				my $b = $c - $a;
				next if $radical[$b] < $rad;
				next if $radical[$b] * $rad > $cextra;
				$sum += $c;
			}
		}
	}
}
print "$sum\n";
