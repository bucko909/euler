# Use the recurrence relation:
# p(n) = sum_{k=1}^n (-1)^{k+1} (p(n+k(3k-1)/2)+p(n-k(3k+1)/2))

$p[1] = 1;
$p[0] = 1;
sub p {
	my $n = $_[0];
	return $p[$n] if $p[$n];
	my $p=0;
	my ($n1, $n2, $e);
	$e = 1;
	for(1..$n) {
		$n1 = $n-$_*(3*$_-1)/2;
		$n2 = $n-$_*(3*$_+1)/2;
		last if $n1 < 0;
		$p += $e * $p[$n1];
		$p += $e * $p[$n2] if $n2 >= 0;
		$e *= -1;
	}
	return $p[$n] = $p % 1000000;
}
for($k=0;p($k);$k++) { }
print "$k\n";
