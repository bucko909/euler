# Similar to the sum of squares one before. Let N(l,m,n,k) be the number of
# cubes to cover the kth layer of an lxmxn cuboid. Let M(l,m,k) be the same in
# 2-D.
# M(1,1,k) = 4k since by rotation we add a square shell of side length k+1
# and overlapping sides. There are 4 sides.
# M(l,1,k) = M(1,1,k) + 2(l-1) since we are just adding a slice to the middle
# of the figure.
# M(l,m,k) = M(l,1,k) + 2(m-1) by the same argument.
# Thus M(l,m,k) = 4k + 2l + 2m - 4
#
# N(1,1,1,k) = 4k(k+1)/2 + 4k(k-1)/2 + 2 = 4k^2 + 2 by observing that we add
# length k 4 times, then all lengths k-1..1 8 times
# (so 4(1+...+k)+4(k-1+...+1)), then cap the top and bottom with 2 cubes.
# N(l,1,1,k) = N(1,1,1,k) + (l-1)M(1,1,k) where M is the 2-D variant, as we're
# just adding some slices to the middle.
# N(l,m,1,k) = N(l,m,1,k) + (m-l)M(l,1,k) for the same reason.
# N(l,m,n,k) = N(l,m,1,k) + (n-1)M(l,m,k)
# Thus N(l,m,n,k) = 4k^2 + 2 + 4k(l-1) + 2(m-1)(2k+l-1) + 2(n-1)(2k+l+m-2)
# = 4k^2 + 2 + 2(l-1)(m-1) + 2(l-1)(n-1) + 2(m-1)(n-1) + 4k(l+m+n-3)
# = 2(lm + ln + mn - 2l - 2m - 2n + 2k(l+m+n+k-3) + 4)
# = 2(lm + ln + mn + (2k-2)(l+m+n+k-3) + 2k - 2)
# = 2(lm + ln + mn + 2(k-1)(l+m+n+k-2))
#
# Having computed N for any set of values we need to solve for l,m,n,k.
# note that N(l,m,n,k) is always even.
#
# Seach l<=m<=n for k giving N around a specific range.

use strict;
use warnings;
my $target = 1000;
my @c;
for (my $pow = 0; ; $pow++) {
	# Use 3 because it coincidentally borders the actual value quite nicely.
	# This cheat speeds the runtime by about 3 times. :)
	my $ubound = 3**($pow+1);
	my $lbound = 3**$pow;
	@c = ((0) x ($ubound-$lbound+1));
	# The following bounds are worked out assuming k>=1 from the formula
	# l^2 <= val/6
	my $lmax = int(sqrt($ubound / 6));
	for (my $l = 1; $l <= $lmax; $l++) {
		# m^2 + 2lm <= val/2
		my $mmax = int(-$l + sqrt($l*$l+$ubound/2));
		for (my $m = $l; $m <= $mmax; $m++) {
			# n <= (val/2 - lm)/(l+m)
			my $nmax = int(($ubound/2 - $l*$m)/($l+$m));
			for (my $n = $m; $n <= $nmax; $n++) {
				my $const = 2*($l*$m+$l*$n+$m*$n-2*($l+$m+$n-2));
				my $kfac = 4*($l+$m+$n-3);
				my $k2fac = 4;
				my $kmin;
				if ($kfac*$kfac > 4*$k2fac*($const-$lbound)) {
					$kmin = (-$kfac + sqrt($kfac*$kfac - 4*$k2fac*($const-$lbound)))/2/$k2fac;
					$kmin = int $kmin; # + 1 if $kmin != int $kmin;
					$kmin = 1 if $kmin < 1;
				} else {
					$kmin = 1;
				}
				# The following loop hacks the use of square roots.
				my $val = $const + $kmin*$kfac + $kmin*$kmin*$k2fac - $lbound;
				$kfac = $kfac + $k2fac*(2*$kmin+1);
				my $max = $ubound-$lbound;
				while($val <= $max) {
					$c[$val]++;
					$val += $kfac;
					$kfac += 8;
				}
			}
		}
	}
	for(0..$#c) {
		if ($c[$_] == $target) {
			print "".($_+$lbound)."\n";
			exit;
		}
	}
}
