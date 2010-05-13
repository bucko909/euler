# Use basically the same recursion as in 114, and reset the cache each time.
my (@b, @r);
sub bstart {
	my ($m, $s) = @_;
	return $b[$s] if defined $b[$s];
	my $t = 0;
	for my $l (0..$s - 1) {
		$t += rstart($m, $l);
	}
	return $b[$s] = $t;
}

sub rstart {
	my ($m, $s) = @_;
	return $r[$s] if defined $r[$s];
	my $t = 0;
	for my $l (0..$s - $m) {
		$t += bstart($m, $l);
	}
	return $r[$s] = $t;
}

$m = 50;
for(my $n = $m + 1; ; $n++) {
	@b = (1, 1);
	@r = (1, ((0) x ($m-1)), 1);
	my $tot = rstart($m, $n) + bstart($m, $n);
	if ($tot > 10**6) {
		print "$n\n";
		last;
	}
}
