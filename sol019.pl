# Just brute force this one. For each month, add the length of the month to the
# day counter, mod 7. If it's a 6, count it.
my @months = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
my $m = 12 * 1900;
my $y;
my $d = 0;
my $tot = 0;
for(; ($y = int($m/12)) < 2001; $m++) {
	my $ym = $m % 12;
	$d = ($d + $months[$ym]) % 7;
	$d++ if $ym == 1 && $y % 4 == 0 && ($ym % 100 != 0 || $ym % 400 == 0);
	$tot++ if $d == 6 && $y >= 1901;
}
print "$tot\n";
