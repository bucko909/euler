# sum_{k=1}^n kr^(k-1) = (d/dr)sum_{k=1}^n r^k = (d/dr)((r-r^(k+1))/(1-r))
# = ((1-r)(1-(k+1)r^k)+(r-r^(k+1)))/(1-r)^2
# = (kr^(k+1)-(k+1)r^k+1)/(r-1)^2

# So must solve 900*(r^k-1)/(r-1) - 3(...) for -600000000000 at k=5000
# Note that the solution will be around close to, and below, -1, or close to,
# and above, 1. Start a bisection search in these areas pulls out the answer.

my $f = sub {
	my ($k, $r) = (5000, @_);
	return 900*($r**$k-1)/($r-1) - 3*($k*$r**($k+1)-($k+1)*$r**$k+1)/(($r-1)**2);
};

sub bisection {
	my ($f, $u, $v, $target) = @_;
	if ($v-$u<10**-15) {
		return ($u+$v)/2;
	}
	my $a = $f->($u) > $f->($v) ? 1 : -1;
	if ($a*$f->(($u+$v)/2) < $a*$target) {
		return bisection($f, $u, ($u+$v)/2, $target);
	} else {
		return bisection($f, ($u+$v)/2, $v, $target);
	}
}

my $ans = bisection($f, 1.000000000000001, 1.1, -6*10**11);
printf("%1.12f\n", $ans);
