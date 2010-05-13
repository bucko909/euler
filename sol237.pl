# Let A(n) be # tours which end with:
#
# -|
#  |
#  |
# -|
#
# Then A(n) = A(n-2) + 2*(A(n-2) + 2*A(n-3) + 3*A(n-4) + ... + (n-2)*A(1))
# And T(n) = A(n) + A(n-1) + A(n-2) + ... + A(1)
#
# The first corresponds to:
# --------|      -\ /-\
# -------||   or  \-/ |
# ---||--||       /-\ |
# ---||---|      -/ \-/
#
# The second to:
# ---|
# |--|
# |--|
# ---|
#
# Also, A(1) = 1.
#
# A(n-1) = A(n-3) + 2*(A(n-3) + ... + (n-3)*A(1))
# = A(n) - A(n-2) + A(n-3) - 2*(A(n-2) + ... + A(1))
# So A(n) = A(n-1) + A(n-2) - A(n-3) + 2*(A(n-2) + ... + A(1))
# So A(n-1) = A(n-2) + A(n-3) - A(n-4) + 2*(A(n-3) + ... + A(1))
# = A(n) - A(n-1) + 2A(n-3) - A(n-4) - 2*A(n-2)
# So A(n) = 2A(n-1) + 2A(n-2) - 2A(n-3) + A(n-4)
#
# Thus T(n) = 2T(n-1) + 2T(n-2) - 2T(n-3) + T(n-4)
#
# There's a Binet-like formula in the roots of x^4 = 2x^3 + 2x^2 - 2x + 1
# ie. x^4 - 2x^3 - 2x^2 + 2x - 1 = 0
# Derivative 4x^3 - 6x^2 - 4x + 2

# Estimate roots with
#=cut
my $f = sub { my $x = $_[0]; $x**4 - 2*$x**3 - 2*$x**2 + 2*$x - 1 };

my $lastval = -1000000;
my @roots;
for my $k ( -100000..100000 ) {
	if (abs($f->($k/100)) < 0.1) {
		push @roots, $k/100 if $k > $lastval + 1;
		$lastval = $k;
	}
}

# Compute accurate roots:
use Lib::NewtonRaphson;
my $f = sub { my $x = $_[0]; $x**4 - 2*$x**3 - 2*$x**2 + 2*$x - 1 };
my $fdash = sub { my $x = $_[0]; 4*$x**3 - 6*$x**2 - 4*$x + 2 };

my @r;
for(-1.28,2.54) {
	push @r, Lib::newton_raphson($f, $fdash, $_);
}

# The roots -1.27620856805625 and 2.53861576354918 aren't the only ones;
# there's a complex conjugate pair, too. Long divide out to get a quadratic.
use Lib::Poly;
my $coeff = [-1, 2, -2, -2, 1];
my $coeff1 = [-1, 2, -2, -2, 1];
for my $r (@r) {
	my $rem;
	($coeff, $rem) = Lib::poly_divide($coeff, [-$r, 1]);
}
my $real = -$coeff->[1] / (2 * $coeff->[2]);
my $imag = sqrt(4*$coeff->[0]*$coeff->[2] - $coeff->[1]**2) / (2 * $coeff->[2]);
my @c = ($real, $imag);

# So the complex roots are 0.368796402253535 +- i0.415511658531306.

# Delightful. Now we know that if these roots are a, b, c, d, that
# T(n) = pa^n + qb^n + rc^n + sd^n
# We need to solve simultaneous equations to get our polynomial.
use Lib::Simultaneous;
# cols are real[0..3], imag[0..3]
my @real = (1, 1, 1, 1, 0, 0, 0, 0);
my @imag = (0, 0, 0, 0, 1, 1, 1, 1);
my @bits = (
	[map { @$_ } mulmul([1, 0], [$r[0], 0], 3)],
	[map { @$_ } mulmul([0, 1], [$r[0], 0], 3)],
	[map { @$_ } mulmul([1, 0], [$r[1], 0], 3)],
	[map { @$_ } mulmul([0, 1], [$r[1], 0], 3)],
	[map { @$_ } mulmul([1, 0], [$c[0], $c[1]], 3)],
	[map { @$_ } mulmul([0, 1], [$c[0], $c[1]], 3)],
	[map { @$_ } mulmul([1, 0], [$c[0], -$c[1]], 3)],
	[map { @$_ } mulmul([0, 1], [$c[0], -$c[1]], 3)],
);
sub mulmul {
	my ($orig, $fac, $max) = @_;
	my @current = @$orig;
	my @ret = ([@current]);
	for(1..$max) {
		@current = ($current[0] * $fac->[0] - $current[1] * $fac->[1],
			$current[0] * $fac->[1] + $current[1] * $fac->[0]);
		push @ret, [@current];
	}
	return @ret;
}
my @mat;
for my $pow (0..3) {
	push @mat, [map { $bits[$_][2*$pow] } (0..7)];
	push @mat, [map { $bits[$_][2*$pow+1] } (0..7)];
}
my $r = Lib::solve_simultaneous([0, 0, 1, 0, 1, 0, 4, 0], @mat);
my @q = @$r;
my @rn = map { $q[2*$_] } 0..3;
my @in = map { $q[2*$_+1] } 0..3;

# test
my @cache = (0, 1, 1);
sub T {
	return 0 if $_[0] <= 0;
	return $cache[$_[0]] if $_[0] < @cache;
	my $ans = 2*T($_[0] - 1) + 2*T($_[0] - 2) - 2*T($_[0] - 3) + T($_[0]-4);
	return $cache[$_[0]] = $ans;
}

# The following code verifies that the formula works up to n=20.
my @real = (1, 1, 1, 1);
my @imag = (0, 0, 0, 0);
my @rm = ($r[0], $r[1], $c[0], $c[0]);
my @im = (0, 0, $c[1], -$c[1]);
for(0..40) {
	my $computed = 0;
	$computed += $real[$_] * $rn[$_] - $imag[$_] * $in[$_] for 0..3;
	my $computedi = 0;
	$computedi += $real[$_] * $in[$_] + $imag[$_] * $rn[$_] for 0..3;
	my $exact = T($_);
	print "$_ $exact\n";
	die "Mistake\n" if $_ < 30 && abs($computed-$exact) + abs($computedi) > 0.5;
	for(0..3) {
		my $nr = $real[$_] * $rm[$_] - $imag[$_] * $im[$_];
		my $ni = $real[$_] * $im[$_] + $imag[$_] * $rm[$_];
		$real[$_] = $nr;
		$imag[$_] = $ni;
	}
}
