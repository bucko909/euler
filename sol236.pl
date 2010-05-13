# Let A(i) and B(i) be per-product and A(0) and B(0) be overall.
# mB'(0)/15744 = A'(0)/18880      => 2^6*5*59mB'(0) = 2^7*3*41A'(0)
# mA'(1)/5248 = B'(1)/640         => 2^7*5mA'(1) = 2^7*41B'(1)
# mA'(2)/1312 = B'(2)/1888        => 2^5*59mA'(2) = 2^5*41B'(2)
# mA'(3)/2624 = B'(3)/3776        => 2^6*59mA'(3) = 2^6*41B'(3)
# mA'(4)/5760 = B'(4)/3776        => 2^6*59mA'(4) = 2^7*3^2*5B'(4)
# mA'(5)/3936 = B'(5)/5664        => 2^5*3*59mA'(5) = 2^5*3*41B'(5)
#

# Simplifying, letting m=p/q gcd(p,q)=1, q<p, have the following integer
# equations:
#
# 5*59pB'(0) =  2*3*41qA'(0)
#    5pA'(1) =      41qB'(1)
#   59pA'(2) =      41qB'(2)
#   59pA'(3) =      41qB'(3)
#   59pA'(4) = 2*3^2*5qB'(4)
#   59pA'(5) =      41qB'(5)
#
# So 5*59p((5pA'(1) + 59p(A'(2)+A'(3)+A'(5))/41q + 59pA'(4)/90q) = 2*3*41qA'(0)
# So 5*59p^2(90(5A'(1) + 59(A'(2)+A'(3)+A'(5))+59*41A'(4)) = 2^2*3^3*5*41^2q^2A'(0)
#
# If p has a prime power not 41 then that prime power divides B'(i). Any prime
# power other than 2, 3 or 5 must divide B'(4). Thus p=41p', p'|B'(i) so
# in particular B'(i) >= p'. If 41 does not divide p, B'(i) >= p. (i=1,2,3,5).
# 
# By a similar argument, either 59|q and q<=59A'(2), or q<=A'(2).
# Either 5|q and p<=5A'(1), or q<=A'(1)

for (my $p=1; $p <= 640; $p++) {
	for (my $q=1; $q <= 1312; $q++) {
		if ($p > $q) {
			check($p, $q);
		}
	}
}
