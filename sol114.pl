# An easy recursion. rstart counts ways starting with a red, bstart if they
# start with a black. They each call the other recursively. 

my (@b, @r);
@b = (1, 1); # Special case.
@r = (1, 0, 0, 1); # Special case.
sub bstart {
	my ($s) = @_;
	return $b[$s] if defined $b[$s];
	my $t = 0;
	for my $l (0..$s - 1) {
		$t += rstart($l);
	}
	return $b[$s] = $t;
}

sub rstart {
	my ($s) = @_;
	return $r[$s] if defined $r[$s];
	my $t = 0;
	for my $l (0..$s - 3) {
		$t += bstart($l);
	}
	return $r[$s] = $t;
}

my $tot = rstart(50) + bstart(50);
print "$tot\n";
