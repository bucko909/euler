# x^2-y^2-z^2=-x^2+2ix+4ix-5i^2=6ix-x^2-5i^2=(5i-x)(x-i)=n
# or y(4i-y)=n or (3i-z)(i+z)=n
# Solve for i,z using factors: i=(u+v)/4, z=u-i so (u+v)/4<u ie. v<3u
# If n is 4 or 16 there is exactly one solution.
# If n is prime, and 4 divides n+1 there is exactly one solution.
# If n if 4 times an odd prime there is exactly one solution.
# If n is 16 times an odd prime there is exactly one solution.
# If n is any other power of 2 times anything there is not one unique solution.
# If n is pq for q nonprime and gcd(n,2)=1, and all prime factors equal 1 mod 4,
# there are no solutions.
# Let k be the number of prime factors (counting duplicates) with p%4=3.
# If k is even there are no solutions. If k is odd then the number of
# solutions is at least 2 since one can place the biggest two or three such
# primes in v. There is a dubious case for n=27 but we know this has 2
# solutions and the above 4 cases are the only ones.
use strict;
use warnings;
use Lib::NumberTheory;
my $target = 50000000;
my $t4 = $target/4;
my $t16 = $target/16;
my @seive;
my @fails;
open P, "primes 1 $target|";
#my $primes = Lib::primes; # My seive is too slow for this many primes...
my $sols = 0;
while(my $p = <P>) {
	chomp $p;
	$sols++ if $p % 4 == 3;
	# These two catch 4*2 and 16*2 but we skip 4 and 16 so it's OK.
	$sols++ if $p < $t4;
	$sols++ if $p < $t16;
}
print "$sols\n";
