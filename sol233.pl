# Have y(N-y)=x(x-N); divide both sides by N^2 to get a(1-a)=b(b-1)
# with a=y/N, b=x/N rationals. Any rational (a, b) results in an integer (x,y,N)
# by setting N=lcm(denoms).
#
# This is the equation of a circle. (a-1/2)^2+(b-1/2)=1/2.
# {0,1}^2 is a set of rational solutions. If m is not 0 or 1, the line (t, mt)
# will intersect another point on the circle. To get a nontrivial sol, t!=0, so
# t(1-t)=mt(mt-1)
# 1-t=m(mt-1), t(m^2+1)=m+1, and t=(m+1)/(m^2+1)
#
# I assume (134) that t is rational iff m is rational.
#
# Now a=(m+1)/(m^2+1) and b=(m^2+m)/(m^2+1)
#
# Let m=p/q with gcd(p,q)=1 and multiply top and bottom by q^2.
# a=(pq+q^2)/(p^2+q^2) b=(p^2+pq)/(p^2+q^2)
#
# So for p,q!=0, and (p,q)!=(1,1) we get the solution
# (x,y,N)=(q(p+q),p(p+q),p^2+q^2). Any multiple of these will work, too.
# As gcd(p,q)=1 and (p,q)!=(1,1), can always get a different sol by swapping
# p,q, and so we can assume |p|>|q|. We can sign flip any one to get a
# different solution, but flipping both is a symmetry, so assume p>0.
#
# If k'p'(p'+q') = kp(p+q), k'q'(p'+q')=kq(p+q), k'(p'^2+q'^2) = k(p^2+q^2)
# Then k'(p'^2-q'^2)=k(p^2-q^2) from first two, so kp^2=k'p'^2, and same for q'.
# If k>k' then p' must take a prime factor from k, and same with q,
# contradiction on gcd(p',q')=1. So k=k', and (p,q)=-(p',q'). Since p'>0 this is
# also a contradiction, so each set of p,q above yields a new solution.
#
# check: N-x=p^2+q^2-q^2-pq=p^2-pq=p(p-q) so x(N-x)=pq(p^2-q^2)=y(y-N).
# (N-x,y) is also meant to be a solution, but plug in (p,-q) to get that etc.
#
# Thus the question is to find how many ways there are of writing factors of N
# as sums of squares p^2+q^2 with q>0,q!=0,p>q,gcd(p,q)=1
#
# If N=2^a0 p1^a1 ... pr^ar q1^br ... qs^rs with ai all multiples of 2,
# pi=3 mod 4 and qi=1 mod 4 primes, there are 4 sum(bi+1) ways of writing N as
# a sum of 2 squares.
#
# When expressing as a sum of squares, each 4k+1 prime factor gets expressed
# individually and the whole is built up using the rule
# (a^2+b^2)(c^2+d^2) = (ac-db)^2+(bc+ad)^2. The different expressions correspond
# to, for each 4k+1 prime power factor p^i, i arrangements of (a^2+b^2) or
# (b^2+a^2), resulting in i+1 possibilities, if i is odd. Divide it by 2 to
# account for the duplicates (do this /after/ including all factors, as the
# factoring still works differently between factors). If N=2^(2j)p^(2i), the
# middle case results in 0^2+sqrt(N)^2, ie. the sum of one square. If
# N=2^(2i+1)p^(2i), this becomes a k^2+k^2. We wanted to discount both of these
# cases above.
#
# Actually, since every two paired bits makes a square, the only essentially
# unique reps are the (0, i) ones; the rest are just square multiples of them.
#
# Anyway, let N have the expression above. Then let B=sum(bi+1).
# If B(N) is odd, F(N) = 8*(B-1)/2+4=4B. Otherwise, F(N)=4B anyway.
# For each of 2 and 2k+1 primes p dividing N, f(N) = sum(F(N/p))
# = prod(bi+1+bi)=4prod(2bi+1)
# 420 = 2^2*3*5*7=4(3*5*7) so expect powers bi to be 1, 2, 3.
# 420 = 4(15*7) so expect 7,3. Similarly 10,2 and 17,1.
# Finally just 52.
#
# 125*13*13*17=359125
use Lib::NumberTheory;
use Lib::Utils;
use strict;
use warnings;

# Derive max required prime
my $maxN = 10**11;
my $mininit = 125*169;
my $mingood = 125*169*17;
my $maxPrime = int($maxN / $mininit);

# Seive time.
my @allprimes = Lib::flatten Lib::hclip { $_ <= $maxPrime + 300} Lib::primes;
my @goodprimes = grep { $_ % 4 == 1 } @allprimes;
# Check how many numbers which are relatively prime to the goodprimes.
my $maxRemain = int($maxN / $mingood);
my @badnum_seive = (0, ((1) x $maxRemain));
for my $p (@goodprimes) {
	for(my $n=$p; $n <= $maxRemain; $n+=$p) {
		$badnum_seive[$n] = 0;
	}
}
my $sumremain = 0;
my @sumremain;
push @sumremain, ($sumremain += $_ * $badnum_seive[$_]) for 0..$maxRemain;
my $total = 0;
for(my $prime1=0; $goodprimes[$prime1]**3<=$maxN/25/13; $prime1++) {
	my $prod1 = $goodprimes[$prime1] ** 3;
	my $div1 = $goodprimes[$prime1 == 0 ? 1 : 0];
	my $maxV1 = int(sqrt($maxN/$prod1/$div1));
	for(my $prime2=0; $goodprimes[$prime2]<=$maxV1; $prime2++) {
		next if $prime2 == $prime1;
		my $prod2 = $prod1 * ($goodprimes[$prime2] ** 2);
		my $maxV = int($maxN/$prod2);
		for(my $prime3=0; $goodprimes[$prime3] <= $maxV; $prime3++) {
			next if $prime3 == $prime1 || $prime3 == $prime2;
			my $prod = $prod2 * $goodprimes[$prime3];
			$total += $prod*$sumremain[int($maxN/$prod)];
		}
	}
}
for(my $prime1=0; $goodprimes[$prime1]**7<=$maxN/5**3; $prime1++) {
	my $prod1 = $goodprimes[$prime1] ** 7;
	my $maxV1 = int(($maxN/$prod1)**(1/3));
	for(my $prime2=0; $goodprimes[$prime2]<=$maxV1; $prime2++) {
		next if $prime2 == $prime1;
		my $prod = $prod1 * ($goodprimes[$prime2] ** 3);
		$total += $prod*$sumremain[int($maxN/$prod)];
	}
}
for(my $prime1=0; $goodprimes[$prime1]**10<=$maxN/5**2; $prime1++) {
	my $prod1 = $goodprimes[$prime1] ** 10;
	my $maxV1 = int(($maxN/$prod1)**(1/2));
	for(my $prime2=0; $goodprimes[$prime2]<=$maxV1; $prime2++) {
		next if $prime2 == $prime1;
		my $prod = $prod1 * ($goodprimes[$prime2] ** 2);
		$total += $prod*$sumremain[int($maxN/$prod)];
	}
}

print "$total\n";
