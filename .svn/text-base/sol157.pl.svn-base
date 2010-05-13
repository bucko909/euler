#!/usr/bin/perl

# This is fantastically easy for it's number.
# If a,b are not coprime, divide by gcd g and multiply p by g.
# If p has a factor, can multiple a and b by it. So need to list out a, b and
# find factors of resulting p.
# Since a,b are coprime, a=2**i 5**j, b=1 or one is a power of 5 while the
# other is a power of 2. Counting factors of these numbers will be fast, so just do it.

use Lib::NumberTheory;
use Lib::Lists;

sub calc {
	my ($n) = @_;

	my $list1 = Lib::hmap { [ $_->[0], $_->[1], 0, 0 ] } Lib::hcross Lib::promote(0..$n), Lib::promote(0..$n);
	my $list2 = Lib::hmap { [ $_->[0], 0, 0, $_->[1] ] } Lib::hcross Lib::promote(0..$n), Lib::promote(1..$n);
	my $list3 = Lib::hmap { [ 0, $_->[0], $_->[1], 0 ] } Lib::hcross Lib::promote(0..$n), Lib::promote(1..$n);

	my $ans =
	Lib::sum
	Lib::flatten
	Lib::hmap { Lib::number_factors(($_->[0] + $_->[1])*10**$n/$_->[0]/$_->[1]) }
	Lib::hgrep { $_->[0] >= $_->[1] }
	Lib::hmap { [
		2**$_->[0] * 5**$_->[1],
		2**$_->[2] * 5**$_->[3],
		] }
	Lib::hconcatenate($list1, $list2, $list3);

	return $ans;
}

my $t = 0;
$t += calc($_) for(1..9);

print "$t\n";
