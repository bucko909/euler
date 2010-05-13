# This one seems not difficult. We just count bouncy and non-bouncy words.
#
# Note that once we have a bouncy word there will be a block of subsequent
# words which are also bouncy. We try to predict this block and skip every
# word in it. (This reduces runtime by a factor of about 12.)

my $bouncy = 0;
my $num;
my $skipto = 0;
for($num = 1; ; $num++) {
	my $temp = $num % 10;
	my $hasinc;
	my $hasdec;
	my $isbouncy = 0;
	my $dignum = -1;
	if ($num < $skipto) {
		$bouncy++;
	} else {
		for(my $num2 = int($num/10); $num2 > 0; $num2 = int($num2/10)) {
			$dignum++;
			my $digit = $num2 % 10;
			if ($temp > $digit) {
				if (defined $hasdec) {
					$isbouncy = 1;
				}
				$hasinc = [ $dignum, $digit, $temp ];
			} elsif ($temp < $digit) {
				if (defined $hasinc) {
					$isbouncy = 1;
				}
				$hasdec = [ $dignum, $digit, $temp ];
			}
			$temp = $digit;
		}
		$bouncy++ if $isbouncy;

		# At this point we know the leftmost digits transitions that were
		# strictly increasing and strictly decreasing, so we don't care about
		# subsequent digits.

		# Using this information, we can rapidly skip large chunks of numbers!
		my $skip = 0;
		if ($isbouncy && $hasinc->[0] > $hasdec->[0]) {
			# The rightmost required digit was a decrease. That means we can
			# skip until the digit left of it, minus 1.
			#
			# Since this is the first numerically we got this property,
			# $hasdec->[2] (the smaller digit) must be zero.
			my $diff = $hasdec->[1];
			$skip = $diff * 10 ** $hasdec->[0];
		} elsif ($isbouncy && $hasinc->[0] < $hasdec->[0]) {
			# The rightmost required digit change was an increase. We can skip
			# all the way up to 9.
			my $diff = 9 - $hasinc->[2];
			$skip = $diff * 10 ** $hasinc->[0];
		}
		if ($skip) {
			$skipto = $num + $skip;
			if (($skipto-1)*99 > ($bouncy+$skip-1)*100) {
				$num = $skipto - 1;
				$bouncy += $skip - 1;
			}
		}
	}

	last if $bouncy * 100 == $num * 99;
}
print "$num\n";
