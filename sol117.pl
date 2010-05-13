# Use recursion to evaluate this one. count() picks each type of block to
# place and then recursively evaluates count on the remainder.

my @cache = (1);
sub count {
	my ($l) = @_;
	return $cache[$l] if defined $cache[$l];
	my $tot;
	for(1..4) {
		if ($l >= $_) {
			$tot += count($l-$_);
		}
	}
	return $cache[$l] = $tot;
}

my $ans = count(50);
print "$ans\n";
