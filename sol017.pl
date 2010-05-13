# Use some known facts to avoid computing strings.
use Lib;
my $sum = 0;
my @l10 = (6, 6, 5, 5, 5, 7, 6, 6); # 20 on
my @lteen = (3, 6, 6, 8, 8, 7, 7, 9, 8, 8); # 10 on
my @digits = (3, 3, 5, 4, 4, 3, 5, 5, 4); # 1 on
my $thousand = length 'thousand';
my $hundred = length 'hundred';
my $and = length 'and';
for(1..1000) {
	my $v = $_;
	my $hasbig = 0;
	if ($v > 999) {
		$sum += $thousand;
		$sum += $digits[int($v/1000)-1];
		$hasbig = 1;
		$v = $v % 1000;
	}
	if ($v > 99) {
		$sum += $hundred;
		$sum += $digits[int($v/100)-1];
		$hasbig = 1;
		$v = $v % 100;
	}
	next if $v == 0;
	$sum += $and if $hasbig;
	if ($v > 19) {
		$sum += $l10[int($v/10) - 2];
		$sum += $digits[$v%10 - 1] if $v % 10;
	} elsif ($v >= 10) {
		$sum += $lteen[$v%10];
	} else {
		$sum += $digits[$v-1];
	}
}
print "$sum\n";
