# Note that n^3 + pn^2 = k^3 imples n^2 divides k^3 and n+p divides k^3
# If p divides n, n=lp so we have (l^3+l^2)p^3 = k^3 and l^2(l+1) is a perfect
# cube. But l shares no factors with l+1 so l^2 and l+1 are both perfect cubes.
# If l^2 is a perfect cube, so is l. So we have both l and l+1 are perfect cubes
# which is impossible. Thus gcd(p,n)=1.
#
# Now gcd(n+p,n)=1 so n^2 (therefore n) is a perfect cube and so is n+p.
#
# It remains to find some l^3 such that l^3+p is also a cube.
# We have (l+i)^3 - l^3 = 3li^2 + 3l^2i + i^3 = p, so i divides p ie. i=1.
# Then 3l^2 + 3l - p + 1 = 0 and l is an integer.
#
# While I grepped the primes, it seems many other people grepped the difference
# of cubes. This is a smaller search space, but assuming no precaching of
# primes is slower. If the primes are precached, we may as well just grep
# them as square root isn't so comparitively slow in Perl.
use Lib::NumberTheory;
use Lib::Lists;
my $ans = Lib::flatten
	Lib::hgrep { $_ == int $_ }
	Lib::hmap { sqrt(12*$_-3)/3 } # Throw aray 9/3 as it's always an integer.
	Lib::hclip { $_ < 1000000 }
	Lib::primes;
=cut
$ans = Lib::flatten
	Lib::hgrep { Lib::is_prime[$_] }
	Lib::hclip { $_ < 1000000 }
	Lib::hmap { 3*$_^2 + 3*$l + 1 }
	Lib::naturals 1;
=cut
print "$ans\n";
