package Lib;
use Lib::Lists;
use Lib::NumberTheory;

#Fold operations use global $a, $b as params.
# optimised foldl { $a + $_ } 0, @list
sub sum(@) {
	my $sum = 0;
	$sum += $_ for @_;
	return $sum;
}

# optimised foldl { $a * $_ }  1, @list
sub product(@) {
	my $product = 1;
	$product *= $_ for @_;
	return $product;
}

sub max(@) {
	my $max = $_[0];
	for(@_[1..$#_]) {
		$max = $_ if $_ > $max;
	}
	return $max;
}

sub min(@) {
	my $min = $_[0];
	for(@_[1..$#_]) {
		$max = $_ if $_ < $min;
	}
	return $min;
}

sub fibonaccis() {
	my $a1 = 0;
	my $a2 = 1;
	return sub {
		$a2 = $a1 + $a2;
		$a1 = $a2 - $a1;
		return $a2;
	}
}

sub is_triangle {
	my $pot = sqrt(1+8*$_[0]);
	return $pot == int $pot && $pot % 2;
}

sub is_palindrome {
	return 1 if length $_[0] == 1;
	my $x = substr($_[0], 0, int(length($_[0])/2));
	$x = join '', reverse split //, $x;
	return $x eq substr($_[0], -int(length($_[0])/2));
}

sub is_pandigital_1 {
	my $val = $_[0];
	my $len = length $val;
	my $count = $len;
	my @digits;
	while($count--) {
		return if $digits[$val%10];
		$digits[$val%10]=1;
		$val = int($val/10);
	}
	return $#digits == $len;
}

our %roman_val = (
	I => 1,
	V => 5,
	X => 10,
	L => 50,
	C => 100,
	D => 500,
	M => 1000,
);
# This /assumes/ the numerals are written according to the validity rules.
# Output is undefined if it's not.
sub read_legit_roman($) {
	my ($x) = @_;
	my @digits = split //, $x;
	my $runningtotal;
	for(my $i = 0; $i < @digits; $i++) {
		if ($i < $#digits && $roman_val{$digits[$i]} < $roman_val{$digits[$i+1]}) {
			$runningtotal -= $roman_val{$digits[$i]};
		} else {
			$runningtotal += $roman_val{$digits[$i]};
		}
	}
	return $runningtotal;
}

sub minimal_roman($) {
	my $x = $_[0];
	my $out = '';
	roman_nom($x, $out, 1000, 'M');
	roman_nom($x, $out, 900, 'CM');
	roman_nom($x, $out, 500, 'D');
	roman_nom($x, $out, 400, 'CD');
	roman_nom($x, $out, 100, 'C');
	roman_nom($x, $out, 90, 'XC');
	roman_nom($x, $out, 50, 'L');
	roman_nom($x, $out, 40, 'XL');
	roman_nom($x, $out, 10, 'X');
	roman_nom($x, $out, 9, 'IX');
	roman_nom($x, $out, 5, 'V');
	roman_nom($x, $out, 4, 'IV');
	roman_nom($x, $out, 1, 'I');
	return $out;
}

sub roman_nom {
	while($_[0] >= $_[2]) {
		$_[0] -= $_[2];
		$_[1] .= $_[3];
	}
}

sub sum_digits($) {
	my $temp = $_[0];
	my $sum = 0;
	while($temp > 0) {
		$sum += $temp % 10;
		$temp /= 10;
	}
	return $sum;
}

# Use Euclid's forumula to generate an infinite list.
sub primitive_pythagorean_triples {
	my $nm = naturals2_radial_strict_increasing;
	return sub {
		my ($m, $n);
		while(($n, $m) = @{$nm->()}) {
			next if ($n + $m) % 2 == 0;
			next if gcd($n, $m) != 1;
			my $c = $n**2 + $m**2;
			my $b = $m**2 - $n**2;
			my $a = 2 * $m * $n;
			($a, $b) = ($b, $a) if $a > $b;
			return [ $a, $b, $c ];
		}
	}
}

# Multiply everything in the above lists by naturals.
sub pythagorean_triples {
	return hmap { [ $_->[0][0] * $_->[1], $_->[0][1] * $_->[1], $_->[0][2] * $_->[1] ] } hcross_diagonal primitive_pythagorean_triples, naturals;
}

my @fac = (1);
sub fac {
	return $fac[$_[0]] if defined $fac[$_[0]];
	return $fac[$_[0]] = $_[0] * fac($_[0]-1);
}

sub ncr {
	my ($n, $r) = @_;
	$r = $n - $r if 2 * $r > $n;
	my $p = 1;
	for(1..$r) {
		$p *= ($n-$r+$_)/$_;
	}
	return $p;
}

1;
