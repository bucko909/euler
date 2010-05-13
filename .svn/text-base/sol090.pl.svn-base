# By evaluating the first cube, we can find a set of numbers required for the
# second. If it's less than 6, we add on some extra sombinations.
# To maintain uniqueness, we require that the first cube is lexically least.
use Lib;
my @list;
my $count = 0;
outer: while(1) {
	Lib::listinc_shortlex_strict_increasing {
		return if @{$_[0]} < 6;
		return if $_[0][$#{$_[0]}] > 9;
		return 1;
	} \@list, 0;
	next if @list < 6;
	last if @list > 6;
	my @bits;
	$bits[$_] = 1 for @list;
	$bits[6] = 1 if $bits[9];
	my @need = ((0) x 10);
	my @need2;
	for my $need (qw/01 04 06 16 25 36 46 64 81/) {
		if ($bits[int($need/10)] && $bits[$need%10]) {
			# This die has both bits. The other one needs one or the other.
			push @need2, [ int($need/10), $need%10 ];
		} elsif ($bits[$need%10]) {
			$need[int($need/10)] = 1;
		} elsif ($bits[int($need/10)]) {
			$need[$need%10] = 1;
		} else {
			next outer;
		}
	}
	# Get rid of useless second order requirements.
	$need[9] = 1 if $need[6];
	@need2 = grep { !$need[$_->[0]] && !$need[$_->[1]] } @need2;

	# Need of a 6 or 9 is union of need of a 9 and a 6.
	if ($need[6]) {
		$need[6] = $need[9] = 0;
		push @need2, [ 6 ];
	}

	for(@need2) {
		if ($_->[0] == 6 || $_->[1] == 6) {
			push @$_, 9;
		}
	}

	my @selector;
	while(1) {
		Lib::listinc_shortlex {
			return if @{$_[0]} < @need2;
			for(0..$#{$_[0]}) {
				return if $_[0][$_] > $#{$need2[$_]};
			}
			return 1;
		} \@selector, 0;
		next if @selector < @need2;
		last if @need2 && @selector > @need2;
		my @using = @need;
		for(0..$#need2) {
			$using[$need2[$_][$selector[$_]]] = 1;
		}
		# @using now contains a necessary set. We must just fill the gaps.
		my @remain;
		for(0..9) {
			push @remain, $_ if $using[$_] == 0;
		}
		if (@remain < 4) {
			next;
		}
		my @filling = ();
		attempt: while(1) {
			if (@remain > 4) {
				Lib::listinc_shortlex_strict_increasing {
					return if @{$_[0]} < @remain - 4;
					return if $_[0][$#{$_[0]}] > $#remain;
					return 1;
				} \@filling, 0;
				next if @remain - @filling > 4;
				last if @remain - @filling < 4;
			}
			my @final = @using;
			$final[$remain[$_]] = 1 for @filling;
			my @contents;
			for(0..9) {
				push @contents, $_ if $final[$_];
			}
			if (!$done{"@list/@contents"} && "@list" le "@contents") {
				$done{"@list/@contents"} = 1;
				$count++;
			}
			last if @remain == 4;
		}
		last unless @need2;
	}
}
print "$count\n";
