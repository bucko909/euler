# We can throw away the tail of really big numbers and just count how many
# times we've done that. After a few initial terms, the length of our number is
# always precisely 10.
# Alternatively, using log_((sqrt(5)-1)/2)(1000) will work...
my $f1 = 1;
my $f2 = 1;
my $term = 2;
my $digits = 0;
while($digits + 10 < 1000) {
	$term++;
	($f1, $f2) = ($f2, $f1 + $f2);
	if ($f2 >= 10**10) {
		$f1 = int($f1/10);
		$f2 = int($f2/10);
		$digits++;
	}
}
print "$term\n";
