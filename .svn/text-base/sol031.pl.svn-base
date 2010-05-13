# Use recursion
use Lib;

sub partitions {
	my ($val, $list) = @_;
	my $spacing = " " x (6 - @$list);
	my $ret;
	if ($val == 0) {
		$ret = 1;
	} elsif (@$list == 1) {
		$ret = $val % $list->[0] == 0 ? 1 : 0;
	} else {
		my @newlist = @{$list}[1..$#$list];
		$ret = 0;
		for(0..int($val/$list->[0])) {
			$ret += partitions($val-$_*$list->[0], \@newlist);
		}
	}
	return $ret;
}

print partitions(200, [200, 100, 50, 20, 10, 5, 2, 1])."\n";
