# The diagonals are (2n+1)^2 - 2in for i = 0 ... 3.
my $sum = 1; # Centre
for my $n (1..500) {
	$sum += 4 * (2*$n + 1)**2;
	$sum -= 12 * $n;
}
print "$sum\n";

