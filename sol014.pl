# Use a cache to save evaluating the same things over and over. It's still very
# slow compared to some C++ solutions.
my @cache = (0, 1);
my $max = 0;
my $maxv = 0;
my $end = 10**6;
for my $val (1..$end) {
	my $test = $val;
	my @seen;
	while(!$cache[$test]) {
		push @seen, $test;
		$test = $test % 2 ? 3*$test + 1 : $test/2;
	}
	my $l = $cache[$test];
	for(reverse @seen) {
		$l++;
		$cache[$_] = $l if $_ < 10**6;
	}
	if ($l > $max) {
		$max = $l;
		$maxv = $val;
	}
}
print "$maxv\n";
