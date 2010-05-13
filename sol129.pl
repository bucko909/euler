# Suppose we are given n. Suppose i>j and R(i) % n = R(j) % n.
# Then n divides R(i)-R(j) = 10^j * R(i-j). But gcd(10,n) = 0 so n divides
# R(i-j). Thus by the pigeonhole principle, A(n) <= n
#
# We need only to compute the residue of R(i) by n for all i and check it's 0.
# R(i) = 0 mod n is equivalent to 9R(i) = 0 mod 9n, so
#     1
#   = 9R(i) + 1 % 9n
#   = 9*(10^i-1)/9 + 1 % 9n
#   = 10^i % 9n
#
# In summary, we want the order of 10, mod 9n.

my $n;
my $target = 10**6;
for($n = $target; ; $n++) {
	next if $n % 2 == 0 || $n % 5 == 0;
	my $ten_i = 10;
	my $an = 1;
	while($ten_i != 1) {
		$an++;
		$ten_i = ($ten_i * 10) % (9*$n);
	}
	last if $an > $target;
}
print "$n\n";
