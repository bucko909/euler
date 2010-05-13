# This is just a minimum spanning tree. Use a greedy algorithm whose name I
# forget. It's probably Kruskal or Prim.

use strict;
use warnings;

my @matrix;
open NET, "network.txt";
while(my $line = <NET>) {
	push @matrix, [ $line =~ /(-|\d+)/g ];
}
close NET;

my @edges;
my $total = 0;
for(my $i = 0; $i <= $#matrix; $i++) {
	for(my $j = 0; $j < $i; $j++) {
		if ($matrix[$i][$j] ne '-') {
			push @edges, [ $i, $j, $matrix[$i][$j] ];
		}
	}
}

@edges = sort { $a->[2] <=> $b->[2] } @edges;

my @tree = (1 .. @matrix);
my $connected = 1;
my $saving = 0;
for(@edges) {
	my $val1 = $tree[$_->[0]];
	my $val2 = $tree[$_->[1]];
	if ($val1 != $val2) {
		# This connects something new
		$connected++;
		# Ugly...
		for(0..$#tree) {
			$tree[$_] = $val2 if $tree[$_] == $val1;
		}
	} else {
		$saving += $_->[2];
	}
#	last if $connected == @matrix;
}
print "$saving\n";
