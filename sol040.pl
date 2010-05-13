# Compute the digit by consuming initial parts of the string.
sub d {
	my $remain = $_[0];
	return 1 if $remain == 1; # This messes up an assumpion below.
	my $bitlen = 0;
	while (++$bitlen) {
		my $add = $bitlen*9*10**($bitlen-1);
		last if $add > $remain;
		$remain -= $add;
	}
	# OK, so the length of the numbers remaining is $bitlen
	my $num = 10**($bitlen-1) + int($remain/$bitlen);
	# We're in the middle of $num.
	$remain %= $bitlen;
	# We're at (1-based) position $remain
	return substr($num, $remain-1, 1);
}
my $ans = d(1)*d(10)*d(100)*d(1000)*d(10000)*d(100000)*d(1000000);
print "$ans\n";
