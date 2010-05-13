# We work by finding all pentagonal differeces and testing for pentagonal sums.
# Note that we have 2D = 2*(n(3n-1)/2 - m(3m-1)/2)
# = 3n^2-n - 3m^2-m
# This is a hyperbolic diophantine equation.
use Lib;
use Lib::NumberTheory;

sub diophantine_solve_hyp_homog {
	my ($a, $b, $c, $f) = @_;
	my $det = $b**2 - 4*$a*$c; # Is +ve
	my $k = sqrt($det);
	if ($f == 0) {
		if ($k != int $k) {
			return Lib::promote([0,0]);
		} else {
			# We get (2ax + (b+k)y)(2ax + (b-k)y) = 0
			# Solutions are those of the linear equations in the factors.
			return Lib::hunion
				diophantine_solve_linear(2*$a, $b+$k),
				diophantine_solve_linear(2*$a, $b-$k);
		}
	}
	if ($det == int $det) {
		# We get (2ax + (b+k)y)(2ax + (b-k)y) = -4af
		# Need to make sure the factors add up.
		my $fac = 1;
	}
}

# a=b=c=0
sub diophantine_solve_linear {
	my ($d, $e, $f) = @_;
	if ($d == 0 && $e == 0) {
		return Lib::hcross_diagonal Lib::ints, Lib::integers;
	} elsif ($d != 0 && $e == 0) {
		if ($f % $d == 0) {
			return Lib::hmap { [ $f / $d, $_ ] } Lib::integers;
		} else {
			return Lib::promote();
		}
	} elsif ($d == 0 && $e != 0) {
		if ($f % $e == 0) {
			return Lib::hmap { [ $_, $e / $d ] } Lib::integers;
		} else {
			return Lib::promote();
		}
	} elsif ($d != 0 && $e != 0) {
		my ($g, $cd, $ce) = Lib::gcd_coefficients($d, $e);
		if ($f % $g == 0) {
			return Lib::hmap {
					[ ($e * $_ - $f * $cd) / $g,
					(-$d * $_ - $f * $ce) / $g ]
				} Lib::integers;
		} else {
			return Lib::promote();
		}
	}
}

# a=c=0
sub diophantine_solve_simple_hyperbolic {
	my ($b, $d, $e, $f) = @_;
	my $det = $d * $e - $b * $f;
	# Have (Bx + E)(By + D) = DE - BF
	if ($det == 0) {
		my @sols;
		if ($e % $b == 0) {
			push @sols, Lib::hmap { [ -$e / $b, $_ ] } Lib::integers;
		}
		if ($d % $b == 0) {
			push @sols, Lib::hmap { [ $_, -$d / $b ] } Lib::integers;
		}
		return Lib::hinterleave @sols;
	} else {
		# Use divisors.
		my ($db, $eb) = ($d % $b, $e % $b);
		return
			Lib::hmap { [ ($_ - $e) / $b, ($det/$_ - $d) / $b ] }
			Lib::hgrep { $_ % $b == $eb && $det/$_ % $b == $db }
			Lib::divisors $det;
	}
}

# b^2-4ac < 0
sub diophantine_solve_elliptic {
	my ($a, $b, $c, $d, $e, $f) = @_;
	# y = (-(Bx + E) +- sqrt((Bx+E)^2 - 4C(Ax^2+Dx+F)))/(2C)
	# Set the sqrt = 0 to get the extremes of x
	my ($left, $right) = quadratic_solve($b*$b-4*$a*$c, 2*($b*$e-2*$c*$d), $e*$e-4*$c*$f);
	return Lib::promote() if !defined $left;
	$left = Lib::ceil $left;
	$right = Lib::floor $right;
	return Lib::hgrep { $_->[1] == int $_->[1] }
		Lib::hinterleave
			((Lib::hmap { [ $_, (-($b*$x+$e) + sqrt(($b*$x+$e)**2 - 4*$c*($a*$x*$x + $d*$x + $f)))/2/$c ] } Lib::naturals($left, $right)),
			(Lib::hmap { [ $_, (-($b*$x+$e) - sqrt(($b*$x+$e)**2 - 4*$c*($a*$x*$x + $d*$x + $f)))/2/$c ] } Lib::naturals($left, $right)));
}

# b^2-4ac=0
sub diophantine_solve_parabolic {
	my ($A, $B, $C, $d, $e, $f) = @_;
	my $g = Lib::gcd($A, $C);
	my ($a, $b, $c) = ($A/$g, $B/$g, $C/$g);
	my $ra = sqrt($a);
	return Lib::promote() if $ra != int $ra;
	my $rb = sqrt($b);
	return Lib::promote() if $rb != int $rb;

}
