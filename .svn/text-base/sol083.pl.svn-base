# This one is just Dijkstra's algorithm.

open M, "matrix.txt";
while(my $m = <M>) {
	chomp $m;
	push @m, [ split /,/, $m ];
}
my (@o, @v, @uv);
my $c = [0, 0];
$o[0][0] = $m[0][0];
while(!$v[$#m][$#m]) {
	$v[$c->[0]][$c->[1]] = 1;
	my $val = $m[$c->[0]][$c->[1]];
	for my$d ([-1, 0], [0, -1], [1, 0], [0, 1]) {
		my $newx = $c->[0] + $d->[0];
		my $newy = $c->[1] + $d->[1];
		next if $newx > $#m || $newx < 0 || $newy > $#m || $newy < 0;
		my $oldv = $o[$newx][$newy];
		my $newv = $o[$c->[0]][$c->[1]]+$m[$newx][$newy];
		if (!$oldv || $newv < $oldv) {
			# Found a new, shorter route.
			$o[$newx][$newy] = $newv;
		}
		if (!$oldv) {
			# We'd not seen this before, so add it to uv queue.
			push @uv, [ $c->[0]+$d->[0], $c->[1]+$d->[1] ];
		}
	}
	my $min = 10000000000000;
	my $mini = -1;
	for(0..$#uv) {
		if ($o[$uv[$_][0]][$uv[$_][1]] < $min) {
			$mini = $_;
			$min = $o[$uv[$_][0]][$uv[$_][1]];
		}
	}
	last unless @uv;
	$c = splice(@uv,$mini,1);
}
print "$o[$#o][$#o]\n";
