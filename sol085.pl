# For a 1*n rectangle, the number of rectangles is clearly 1 + 2 + ... + n =
# n ( n + 1 ) / 2. For a larger one, note that all rectangles project to both
# axes as 1*n and n*1 rectangles. This is a 1:1 correspondance, so we need
# only multiply the two.

# Now, given the width w, we want 2*10^6 / ( w ( w + 1 ) / 2 ) = h (h + 1) / 2
# ie. h^2 + h - 8 * 10^6 / ( w ( w + 1 ) ) = 0
# So h = ( -1 +- sqrt(1 + 32 * 10^6 / ( w ( w + 1 ) ) ) ) / 2
# They cross over at n^4 + n^2 - 8*10^6 = 0
# ie. n = sqrt( ( -1 + sqrt( 1 + 32*10^6 ) ) / 2 )

sub rects {
	my ($w, $h) = @_;
	my $wrects = $w * ($w + 1) / 2;
	my $hrects = $h * ($h + 1) / 2;
	return $wrects * $hrects;
}

sub abs($) {
	return $_[0] > 0 ? $_[0] : -$_[0];
}

my $maxn = int(sqrt((-1+sqrt(1+32*1000000))/2));
my $min = 10000000;
my $minarea;
for my $w (1..$maxn) {
	my $wc = $w * ($w + 1);
	my $h1 = int((-1+sqrt(1+32*1000000/$wc))/2);
	# Check both sides of 2 million
	for my $h ($h1, $h1 + 1) {
		if (abs(2*1000000-rects($w, $h)) < $min) {
			$min = abs(2*1000000-rects($w, $h));
			$minarea = $w * $h;
			my $rects = rects($w, $h);
			print "Newmin $w $h $min $minarea $rects\n";
		}
	}
}
print "$minarea\n";
