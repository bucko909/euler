# The length of the recurring cycle is the mult order of 10, mod n.
# Therefore just keep multiplying mod n until we get a repeat.
my $max = 0;
my $maxv;
for my $d(1..1000) {
	my $k = 10 % $d;
	my @k;
	my $f = -1;
	my $l = 0;
	while($k >= 1 && !defined $k[$k]) {
		$k[$k] = $l++;
		$k = ($k * 10) % $d;
	}
	next if $k == 0;
	if ($max < $l - $k[$k]) {
		$maxv = $d;
		$max = $l - $k[$k];
	}
}
print "$maxv\n";
