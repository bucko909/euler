# If a = bc and p | a then provided b and c are (Gaussian) coprime then
# p | b or b | c. So we need to check that (integer) primes are all
# (Gaussian) coprime.
#
# Since all complex factors appear in conjugate pairs, if n+im|p then
# p/(n+im)=p(n-im)/(n+im)(n-im)=p(n-im)/(n^2+m^2) is an integer. Assuming
# n+im is not integer factorable (it'd better not be!), then, we find that
# p=n^2+m^2.
#
# So p = 1 mod 4 if p has factors at all, and all factors are built using
# the numbers that p is the sum of the square of. These numbers are unique
# for a given p.
#
# If n = p q for coprimes p, q then obviously the divisors are just
# multiples of the divisors for p and q.
#
# Back to our expressions, notice that for n+im=i(m-in), so all the factors
# of one integer prime are just conjugates or unit multiples of each other.
# What of p^k? Suppose a+ib is a divisor of p^k. Then due to the expressions
# as sums of squares, we know we can make a+ib by multiplying divisors of p.
# Every pair of conjugates we use gets a copy of p, so we notice that the
# result is (n+im)p^l or a conjugate/unit multiple of that, for some l.
#
# For a number n=(a+ib)^x(c+id)^y then (where the factors are prime), the
# divisor sum is 2(a+b)(sum_{k<x,l<=y} p^kq^l) + 2(c+d)(sum_{k<=x,l<y} p^kq^l)
# + 2(a+b)(c+d)(sum_{k<x,l<y} p^kq^l) + sum_{k<=x,l<=y} p^kq^l
# = 2(a+b)(sum_divs(n/p)) + 2(c+d)(sum_divs(n/q))
# + 2(a+b)(c+d)(sum_divs(n/pq)) + sum_divs(n)
#
# [After consulting The Internets.]
# Notice that when such a minimal gaussian integer appears, the coffients of
# 1 and i are (integer) coprime. Thus we need only search for coprime integers
# a, b and expressions (a+bi)(a-bi)m < 10**8, then add twice (a+b)*sum_divs(m)
# to our ongoing sum. There is a special case for b=0 and a=1 (integer
# divisors) and a=b=1 (to save a bunch of GCD calcs).
#
# A quick hack is that sum(sum(divisors)_<n) = sum_{1...n} k floor(n/k), so
# finding these divisors is pretty easy.
#
# Result takes 4.5 minutes on my PC; 

my @div;
sub div {
	my($n)=int($_[0]);
	return $div[$n] if defined $div[$n];
	my $div = 0;
	# My (quadratic) version from OEIS.
	$div += $_*int($n/$_) for 1..$n;
	# Stolen from Euler forum; saves some time.
#	my $l1 = int(sqrt($n));
#	my $l2 = int($n/(1+$l1));
#	$div += $_*int($n/$_) for 1..$l2;
#	$div += $_*(int($n/$_)*int($n/$_+1)/2-int($n/($_+1))*int($n/($_+1)+1)/2) for 1..$l1;
	$div[$n]=$div if $n<10000;
	return $div;
}
my $lim = 10**8;
my $sum = div($lim) + 2*div($lim/2);
for my$a (1..int(sqrt($lim/2))) {
	my $a2 = $a*$a;
	my $rem = $lim-$a2;
	for my $b($a+1..int(sqrt($rem))) {
		my ($x,$y) = ($a,$b);
		($x,$y)=($y,$x%$y) while$y;
		next unless $x==1;
		my $v = $a2 + $b*$b;
		$sum += 2*($a+$b)*div($lim/$v);
	}
}
print "$sum\n";
