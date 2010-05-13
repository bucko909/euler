my $a = '1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679';
my $b = '8214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196';

exit if length $a != length $b;
my $strlen = length $a;

use Math::BigInt;

sub find_digit {
	my ($v, $as, $bs) = @_;
	if ($v <= length($as)) {
		return substr($as, $v-1, 1);
	}
	my $a2 = Math::BigInt->new(length($as));
	my $a = Math::BigInt->new(length($bs));
	my @my_fibs;
	while($a < $v) {
		push @my_fibs, $a2;
		($a, $a2) = ($a+$a2, $a);
	}
	my $i = $#my_fibs;
	while($i >= 0) {
		if ($v > $my_fibs[$i]) {
			# It's in the terminal segment, so look in the previous number
			# and offset v.
			$v -= $my_fibs[$i];
			$i--;
		} else {
			# It's in the initial segment, which is 2 before.
			$i -= 2;
		}
	}
	if ($i == -2) {
		return substr($as, $v-1, 1);
	} else {
		return substr($bs, $v-1, 1);
	}
}

my $ans = join '', reverse map {
	my $n = Math::BigInt->new($_);
	find_digit((127+19*$n)*7**$n, $a, $b)
} 0..17;
print "$ans\n";
