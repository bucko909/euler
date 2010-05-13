# This is just an ncr problem. Replacing n tiles of width 1 with m tiles of
# width l is just like choosing l tiles from a set of n-(w-1)l.

sub ncr {
	my ($n, $r) = @_;
	$r = $n - $r if 2 * $r > $n;
	my $prod = 1;
	for(1..$r) {
		$prod *= ($n - $_ + 1) / $_;
	}
	return $prod;
}

my $tot = 0;
my $l = 50;
for(1..int($l/2)) {
	$tot += ncr($l-$_, $_);
}
for(1..int($l/3)) {
	$tot += ncr($l-2*$_, $_);
}
for(1..int($l/4)) {
	$tot += ncr($l-3*$_, $_);
}
print "$tot\n";
