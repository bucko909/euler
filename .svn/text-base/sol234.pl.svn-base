# For large n, if both lps(n)=p and ups(n)=q divide n, we have n=pq as if
# there is even one more prime factor, say n=2pq then p is no longer lps(n).
# Note that semidivisible numbers are also not prime squares.
# "Large" in the context above implies p>=2 so n>=4 as specified.
# If p=lps(n) divides n and q is the next prime, then n=pr with p<r and n<q^2
# and q does not divide r.
# If q=ups(n) divides n and p is the prev prime, then n=qr with q>r and n>p^2
# and p does not divide r.
# Thus we need p*sum(p+1,floor(q^2/p)) and q*sum(ceil(p^2/q),q-1) possibly with
# the relevant primes cut out of the sums.

use Lib::Lists;
use Lib::NumberTheory;
my $target = 999966663333;
# Seive
my $primes = Lib::primes;
my $prev = $primes->(); # 2
my $sum = 0;
my $lastsum = 0;
while(my $prime = $primes->()) {
	# lps block.
	$sum += $prev*sumall($prev+1, int($prime*$prime/$prev), $prime, $target/$prev);
	# ups block
	$sum += $prime*sumall(int($prev*$prev/$prime)+1, $prime-1, $prev, $target/$prime);
	$prev = $prime;
	last if $lastsum == $sum;
	$lastsum = $sum;
}
print "$sum\n";

sub sumall {
	my ($min, $max, $exc, $mmax) = @_;
	if ($max > $mmax) {
		$max = int $mmax;
	}
	my $includes;
	if ($exc > $min) {
		$includes = $max >= $exc;
	} else {
		$includes = $min <= $exc;
	}
	my $sum = $max*($max+1)/2 - $min*($min-1)/2;
	$sum -= $exc if $includes;
	my $add = $max-$min+($includes?0:1);
	$count += $add if $add > 0;
	return $sum > 0 ? $sum : 0;
}
