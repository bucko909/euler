package Lib;

use strict;
use warnings;

sub newton_raphson {
	my ($f, $fdash, $current) = @_;
	my $diff = 1000;
	my $count = 0;
	while ($diff > 0 && $count++ < 30) {
		my $new = $current - $f->($current) / $fdash->($current);
		$diff = abs($new-$current);
		$current = $new;
	}
	return $current;
}

1;
