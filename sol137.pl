# F_n = (G^n - G'^n)/sqrt(5) G=(sqrt(5)+1)/2 G'=1-G so the sum is
# n = (1/sqrt(5)) * sum ((Gx)^n - (G'x)^n)
#   = 1/sqrt(5) * (Gx/(1-Gx) - G'x/(1-G'x))
#   = (Gx(1-G'x) - G'x(1-Gx))/((Gx-1)(G'x-1)sqrt(5))
#   = ((G-G')x)/((1-Gx)(1-G'x)sqrt(5))
#   = (x(2G-1))/(-x^2-x+1)sqrt(5)
#   = x sqrt(5)/(-x^2-x+1)sqrt(5)
#   = x / (-x^2 - x + 1)
# So nx^2 + x(n+1) - n = 0
# So 2nx = -(n+1) +- sqrt((n+1)^2+4n^2)
# So 5n^2+2n+1 is a perfect square.
# We are solving 5(n+1/5)^2+4/5-k^2=0
# So (5n+1)^2-5k^2=-4
#
# Solving this diophantine equation (or the earlier one) via Dario's solver
# yields a superset of the answer. Now just filter the results.
#
# Turns out they are of the form F(2n)F(2n+1)! (TODO)

my ($a, $b) = (0, 1);
for(1..15) {
	($a, $b) = ($b, $a + $b);
	($a, $b) = ($b, $a + $b);
}
my $ans = $a * $b;
print "$ans\n";
