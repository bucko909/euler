# Recursive solution with memoisation. Not really much more to say. It's not
# even a very efficient memoisation; stores 85 keys and executes about 380
# recursive calls.
my %cache = ("0" => 0);
sub branch {
	my (@sheets) = @_;
	return 0 if $sheets[$#sheets] == 0;
	return $cache{"@sheets"} if exists $cache{"@sheets"};
	my $expected = @sheets == 1 ? 1 : 0;
	for(0..$#sheets) {
		$expected += branch(sort(@sheets[0..$_-1,$_+1..$#sheets], 0..$sheets[$_]-1));
	}
	$expected /= @sheets;
	return $cache{"@sheets"} = $expected;
}

my $e = branch(0,1,2,3);
printf("%0.6f\n",$e);
