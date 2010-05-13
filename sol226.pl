# Note that the sum terminates nicely for any dyadic rational m/2^n
# Use 1/2^n as the strip width
my $last;
for(my $power = 10; ; $power++) {
	my $denom = 2**$power;
	my $lastval = 0; # value at 1/2.
	my $sum = 0;
	for(my $num = $denom/2; $num >= 0; $num--) {
		# Start from a slightly higher number to give the function a small
		# "kick". It's strictly larger than our endpoints at all times, and
		# the error caused by this will tend to zero anyway.
		my $thisval = 0.5;
		my $mod = $denom;
		for(0..$power-1) {
			my $sof = $num % $mod;
			$sof = $mod - $sof if $sof > $mod/2;
			$thisval += $sof;
			$mod >>= 1;
		}
		$thisval /= $denom;
#		print "$num/$denom -> $thisval\n";
		my $circh = 0.5 - sqrt(.25 - 4 * ($num/$denom - 0.25)**2)/2;
#		print "ch $circh\n";
		$thisval -= $circh;
		$thisval /= $denom;
#		print "-> $thisval\n";
		if ($thisval < 0) {
			last;
		} else {
			$sum += ($thisval+$lastval)/2;
		}
		$lastval = $thisval;
	}
	if (substr($last,0,10) eq substr($sum,0,10)) {
		printf("%0.8f\n", $sum);
		last;
	}
	$last = $sum;
}
