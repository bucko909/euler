# Generate all primitive triples of sufficiently small perimiter, then bung
# multiples in.

use Lib;
use strict;
use warnings;
my @primitive_perimiters =
	grep { $_ <= 1000 }
	map { Lib::sum @$_ }
	Lib::flatten
	Lib::hclip { $_->[2] <= 500 }
	Lib::primitive_pythagorean_triples;

my @count = ((0) x 1001);
for my $perim (@primitive_perimiters) {
	for my $mul (1..int(1000/$perim)) {
		$count[$mul*$perim]++;
	}
}

my $max = 0;
my $maxv;
for(1..1000) {
	if($max < $count[$_]) {
		$max = $count[$_];
		$maxv = $_;
	}
}

print "$maxv\n";
