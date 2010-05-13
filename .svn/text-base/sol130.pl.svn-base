# We need only to compute the residue of R(i) by n for all i and check it's 0.
# R(i) = 0 mod n is equivalent to 9R(i) = 0 mod 9n, so
#     1
#   = 9R(i) + 1 % 9n
#   = 9*(10^i-1)/9 + 1 % 9n
#   = 10^i % 9n
#
# In summary, we want the order of 10, mod n.
use Lib::NumberTheory;

my $sum = 0;
my $target = 25;
my $count = 0;
for(my $n = 3; ; $n++) {
	next if $n % 2 == 0 || $n % 5 == 0;
	next if Lib::is_prime($n);
	my $ten_i = 10;
	my $an = 1;
	while($ten_i != 1) {
		$an++;
		$ten_i = ($ten_i * 10) % (9*$n);
	}
	next unless ($n - 1) % $an == 0;
	$sum += $n;
	$count++;
	last if $count >= $target;
}
print "$sum\n";
