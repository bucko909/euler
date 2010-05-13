# This looks like simulation.
# It's possible to solve for the vector using I-2(I.N)N, but I was too lazy
# to do the algebra. Besides, the ellipse has a perimiter less than 30, so
# there's at most about (30/0.02)^2=1500^2=2250000 possible reflections, which
# can be done in reasonable time anyway.

use Math::Trig qw/cotan pi/;
use strict;
use warnings;
my ($ox, $oy) = (0, 10.1);
my ($x, $y) = (1.4, -9.6);
my ($dx, $dy) = ($x-$ox, $y-$oy);
my $count = 0;
while(abs($x)>0.01 || $y < 0) {
	my $s = $x*$x*4+$y*$y;
	my $grad = -4*$x/$y;
	my $ang = atan2($grad,1);
	$ang *= 2;
	($dx, $dy) = ($dx*cos($ang) + $dy*sin($ang), $dx*sin($ang) - $dy*cos($ang));
	# Now solve 4(x+k*rx)^2+(y+k*ry)^2=100
	# So 4x^2+y^2-100+8k*rx*x+4k^2*rx^2+2k*ry*y+k^2*ry^2=0
	# k=0 is one solution. If k != 0 have k(4rx^2+ry^2)=-(8x*rx+2y*ry)
	# So k=...
	my $k = -(8*$x*$dx+2*$y*$dy)/(4*$dx*$dx+$dy*$dy);
	($ox, $oy, $x, $y) = ($x, $y, $x+$dx*$k, $y+$dy*$k);
	$count++;
}
print "$count\n";

