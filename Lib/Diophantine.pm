package Lib;
use Lib::NumberTheory;
use Lib::Lists;
use Math::BigInt;
#use strict;
use warnings;

sub diophantine_solve {
	my ($A, $B, $C, $D, $E, $F) = @_;
	if ($A == 0 && $C == 0) {
		if ($B == 0) {
			return diophantine_solve_linear($D, $E, $F);
		} else {
			return diophantine_solve_hyperbolic_simple($B, $D, $E, $F);
		}
	}
	my $det = $B**2 - 4*$A*$C;
	if ($det < 0) {
		return diophantine_solve_elliptic($A, $B, $C, $D, $E, $F);
	} elsif ($det == 0) {
		return diophantine_solve_parabolic($A, $B, $C, $D, $E, $F);
	} elsif ($D == 0 && $E == 0) {
		return diophantine_solve_hyperbolic_homogeneous($A, $B, $C, $F);
	}
	# General case.
	my $g = Lib::gcd(4*$A*$C-$B**2, 2*$A*$E-$B*$D);
	# Use substitutions x1 = 2Ax + By + D, y1 = (4AC-B^2)/gy + (2AE-BD)/g
	return hgrep { $_->[1] == int $_->[1] && $_->[0] == int $_->[0] }
		hmap {
			my $y = ($g * $_->[1] - 2*$A*$E + $B*$D)/-$det;
			[ @$_, ($_->[0] - $D - $B*$y) / 2*$A, $y ]
		} diophantine_solve_hyperbolic_homogeneous(-$det/$g, 0, $g,
			4*$A*(4*$A*$C*$F - $A*$E - $B**2*$F + $B*$D*$E - $C*$D**2)/$g);
}

# a=b=c=0
sub diophantine_solve_linear {
	my ($D, $E, $F) = @_;
	if ($D == 0 && $E == 0) {
		return Lib::hcross_diagonal Lib::ints, Lib::integers;
	} elsif ($D != 0 && $E == 0) {
		if ($F % $D == 0) {
			return Lib::hmap { [ $F / $D, $_ ] } Lib::integers;
		} else {
			return Lib::promote();
		}
	} elsif ($D == 0 && $E != 0) {
		if ($F % $E == 0) {
			return Lib::hmap { [ $_, $E / $D ] } Lib::integers;
		} else {
			return Lib::promote();
		}
	} elsif ($D != 0 && $E != 0) {
		my ($g, $cd, $ce) = Lib::gcd_coefficients($D, $E);
		if ($F % $g == 0) {
			return Lib::hmap {
					[ ($E * $_ - $F * $cd) / $g,
					(-$D * $_ - $F * $ce) / $g ]
				} Lib::integers;
		} else {
			return Lib::promote();
		}
	}
}

# a=c=0
sub diophantine_solve_hyperbolic_simple {
	my ($B, $D, $E, $F) = @_;
	my $det = $D * $E - $B * $F;
	# Have (Bx + E)(By + D) = DE - BF
	if ($det == 0) {
		my @sols;
		if ($E % $B == 0) {
			push @sols, Lib::hmap { [ -$E / $B, $_ ] } Lib::integers;
		}
		if ($D % $B == 0) {
			push @sols, Lib::hmap { [ $_, -$D / $B ] } Lib::integers;
		}
		return Lib::hinterleave @sols;
	} else {
		# Use divisors.
		my ($db, $eb) = ($D % $B, $E % $B);
		return
			Lib::hmap { [ ($_ - $E) / $B, ($det/$_ - $D) / $B ] }
			Lib::hgrep { $_ % $B == $eb && $det/$_ % $B == $db }
			Lib::divisors $det;
	}
}

sub quadratic_solve {
	my ($a, $b, $c) = @_;
	$a *= 2;
	my $sq = sqrt($b*$b-2*$a*$c)/$a;
	my $bbit = -$b/$a;
	return $a > 0 ? ($bbit-$sq,$bbit+$sq) : ($bbit+$sq,$bbit-$sq);
}

sub ceil {
	my $a = $_[0];
	return $a == int $a ? $a : $a > 0 ? int($a+1) : int $a;
}

sub floor {
	my $a = $_[0];
	return $a == int $a ? $a : $a > 0 ? int $a : int($a+1);
}

# b^2-4ac < 0
sub diophantine_solve_elliptic {
	my ($A, $B, $C, $D, $E, $F) = @_;
	# y = (-(Bx + E) +- sqrt((Bx+E)^2 - 4C(Ax^2+Dx+F)))/(2C)
	# Set the sqrt = 0 to get the extremes of x
	my ($left, $right) = quadratic_solve($B**2-4*$A*$C, 2*($B*$E-2*$C*$D), $E**2-4*$C*$F);
	return Lib::promote() if !defined $left;
	$left = Lib::ceil $left;
	$right = Lib::floor $right;
	my $l;
	return Lib::hgrep { my $r = $_->[1] == int $_->[1] && $_->[0] == int $_->[0] && (!defined $l || $l != $_->[1]); $l = $_->[1]; $r }
		Lib::hinterleave (
			(Lib::hmap { [ $_, (-($B*$_+$E) + sqrt(($B*$_+$E)**2 - 4*$C*($A*$_**2 + $D*$_ + $F)))/2/$C ] } Lib::naturals($left, $right)),
			(Lib::hmap { [ $_, (-($B*$_+$E) - sqrt(($B*$_+$E)**2 - 4*$C*($A*$_**2 + $D*$_ + $F)))/2/$C ] } Lib::naturals($left, $right))
		);
}

# b^2-4ac=0
sub diophantine_solve_parabolic {
	my ($A, $B, $C, $D, $E, $F) = @_;
	my $g = Lib::gcd($A, $C);
	my ($a, $b, $c) = ($A/$g, $B/$g, $C/$g);
	# b^2 = 4ac, so a, c are perfect squares and b is even.
	return if $b % 2 == 1;
	my $ra = sqrt($a);
	return Lib::promote() if $ra != int $ra;
	my $rc = sqrt($c);
	$rc *= -1 if ($b/$a < 0);
	return Lib::promote() if $rc != int $rc;

	# Can re-arrange to (sqrt(c)D - sqrt(a)E)y = sqrt(a)gu^2 + Du + sqrt(a)F
	# Where u = sqrt(a)x + sqrt(c)y. Integer solutions to the original equation
	# yield integer solutions to this.
	my $ycoef = $rc * $D - $ra * $E;
	if ($ycoef == 0) {
		# If the LHS is zero we need to solve the quadratic for zeros.
		my @sols = quadratic_solve($ra*$g, $D, $ra*$F);
		return hgrep { $_->[1] == int $_->[1] }
			hinterleave (
				map { diophantine_solve_linear($ra, $rc, -$_) }
				grep { $_ == int $_ } @sols
			);
	} else {
		# RHS should be multiple of LHS. Do some guesswork to find some possible
		# solution values
		print "$ycoef $g $rc $D $ra $E\n";
		my $xt2coef = $rc * $g * -$ycoef;
		my $yt2coef = $ra * $g * $ycoef;
		return hinterleave (
			map {
				my $sol = $_;
				my $xtcoef = -($E + 2*$rc*$g * $sol);
				my $ytcoef = $D + 2*$ra*$g * $sol;
				my $xadd = -($rc*$g*$sol**2 + $E*$sol + $rc*$F) / $ycoef;
				my $yadd = ($ra*$g*$sol**2 + $D*$sol + $ra*$F) / $ycoef;
				hmap { [ $sol, $yt2coef, $ytcoef, $yadd, $xt2coef * $_**2 + $xtcoef * $_ + $xadd,
					$yt2coef * $_**2 + $ytcoef * $_ + $yadd ] }
				integers
			}
			grep { ($ra*$g*$_**2 + $D*$_ + $ra*$F) % $ycoef == 0 }
			(0..int(abs($ycoef)))
		);
	}
}

sub diophantine_solve_hyperbolic_homogeneous {
	my ($A, $B, $C, $F) = @_;
	my $det = $B**2 - 4*$A*$C; # Is +ve
	my $k = sqrt($det);
	if ($F == 0) {
		if ($k != int $k) {
			return Lib::promote([0,0]);
		} else {
			# We get (2ax + (b+k)y)(2ax + (b-k)y) = 0
			# Solutions are those of the linear equations in the factors.
			return Lib::hinterleave (
				diophantine_solve_linear(2*$A, $B+$k, 0),
				diophantine_solve_linear(2*$A, $B-$k, 0),
			);
		}
	}
	if ($k == int $k) {
		# We get (2ax + (b+k)y)(2ax + (b-k)y) = -4af
		# Need to make sure the factors add up.
		my $divisors = Lib::divisors 4*$A*$F;
		my $div;
		return hgrep { $_->[1] == int $_->[1] && $_->[0] == int $_->[0] }
			sub {
				if ($div) {
					my $y = -($_ + 4*$A*$F/$_)/2/$k;
					undef $div;
					return [ -($_ + ($B+$k)*$y) / 2 / $A, $y ];
				} else {
					$div = $divisors->();
					return unless defined $div;
					my $y = ($_ + 4*$A*$F/$_)/2/$k;
					return [ ($_ - ($B+$k)*$y) / 2 / $A, $y ];
				}
			};
	}
	if (4*$F**2 < $det) {
		# Solutions among the convergents of At^2 + Bt + C = 0
		return hgrep { evaluate_quadratic(@$_, $A, $B, $C, 0, 0, $F) == 0 }
			hinterleave(
				continued_fraction_convergents_bigint(
					quadratic_continued_fraction_coefficients_initial(-$B,$B*$B-4*$A*$C,2*$A)),
				continued_fraction_convergents_bigint(
					quadratic_continued_fraction_coefficients_initial($B,$B*$B-4*$A*$C,-2*$A)),
			);
	} else {
		my $gab = gcd($A, $B);
		my $gbc = gcd($B, $C);
		return hinterleave(
			map {
				my $div = $_; # gcd(x, y)
				my $sdiv = sqrt($div);
				my $F = $F / $div;
				if (4*$F*$F < $det) {
					return hmap { [ $sdiv * $_->[0], $sdiv * $_->[1] ] }
						hgrep { evaluate_quadratic(@$_, $A, $B, $C, 0, 0, $F) == 0 }
						hinterleave(
							continued_fraction_convergents_bigint(
								quadratic_continued_fraction_coefficients_initial(-$B,$B*$B-4*$A*$C,2*$A)),
							continued_fraction_convergents_bigint(
								quadratic_continued_fraction_coefficients_initial($B,$B*$B-4*$A*$C,-2*$A)),
						);
				} elsif (gcd($gab, $_) == 1) {
					return Lib::promote();
				} elsif (gcd($gbc, $_) == 1) {
					return Lib::promote();
				} else {
					return Lib::promote();
				}
			} Lib::flatten Lib::square_divisors($F)
		);
	}
}

sub evaluate_quadratic {
	my ($x, $y, $A, $B, $C, $D, $E, $F) = @_;
	return $x*$x*$A+$x*$y*$B+$y*$y*$C+$x*$D+$y*$E+$F;
}

# Ensure Q divides D - P^2
sub fix_quadratic_coefficients {
	my ($P, $D, $Q) = @_;
	return ($P*abs($Q), $D*$Q**2, $Q*abs($Q));
}

# (P + sqrt(D)) / Q, D not a perfect square
# Use this for a few initial coefficients. It is inefficient to use it for long
# sequences
sub quadratic_continued_fraction_coefficients_initial {
	my ($P, $D, $Q) = fix_quadratic_coefficients(@_);
	my $floorroot = int(sqrt($D));
	return sub {
		my $alpha = ($P + $floorroot) / $Q;
		my $a = $alpha > 0 ? int($alpha) : int($alpha) - 1;
		$P = $a * $Q - $P;
		$Q = ($D - $P**2)/$Q;
		return $a;
	}
}

# This one returns the initial segment and repeating part as a pair of array
# refs. Build the list with concat_loop(\@a, \@b).
sub quadratic_continued_fraction_coefficients_repeating {
	my ($P, $D, $Q) = fix_quadratic_coefficients(@_);
	my $floorroot = int(sqrt($D));
	my @arr;
	my %seen;
	my $cache_pos = 0;
	while(1) {
		my $alpha = ($P + $floorroot) / $Q;
		my $a = $alpha > 0 ? int($alpha) : int($alpha) - 1;
		$P = $a * $Q - $P;
		$Q = ($D - $P**2)/$Q;
		$cache = "$P.$Q.$a";
		last if exists $seen{$cache};
		$seen{$cache} = $cache_pos++;
		push @arr, $a;
	}
	$cache_pos = $seen{$cache};
	return ([@arr[0..$cache_pos-1]], [@arr[$cache_pos..$#arr]]);
}

sub quadratic_continued_fraction_coefficients_long {
	my ($i, $f) = quadratic_continued_fraction_coefficients_repeating(@_);
	my $p = 0;
	return sub {
		if (@$i) {
			return shift @$i;
		}
		return $f->[$p++ % @$f];
	}
}

# Pass in continued fraction, get convergents.
sub continued_fraction_convergents_bigint {
	_continued_fraction_convergents($_[0], map { Math::BigInt->new($_) } (0, 1, 1, 0));
}

sub continued_fraction_convergents {
	_continued_fraction_convergents($_[0], 0, 1, 1, 0);
}

sub _continued_fraction_convergents {
	my ($frac, $q, $qo, $p, $po) = @_;
	return sub {
		my $a;
		if (defined($a = $frac->())) {
			($p, $po) = ($a * $p + $po, $p);
			($q, $qo) = ($a * $q + $qo, $q);
			return [ $p, $q ];
		} else {
			return;
		}
	}
}


1;
