# For this problem, we use matrices. The first thing to note is that, ignoring
# the double rule and special actions, we can take a vector of current
# probabilities and multiply it by a skewed [ 0, 0, 1/16, 2/16, 3/16, 4/16,
# 3/16, 2/16, 1/16, 0, 0, ... ] repeated matrix (that's a column) to get the
# distribution for the next turn. We can then do the special squares with a
# matrix that represents the chance, community chest, go to jail etc. Multiply
# them together to get a 40x40 matrix which explains exactly how the
# distribution changes /ignoring the doubles rule/.
# To emulate the doubles rule, make 3 copies of the grid, one for "just rolled
# 0 doubles", 1 for 1, and one for 2. The 2 grid sends you to jail on all
# doubles (1/4 chance). Thus, the distributions are [ 0, 0, 0, 2/16, 2/16,
# 4/16, 2/16, 2/16, 0, 0, 0, ... ] and [ 0, 0, 1/16, 0, 1/16, 0, 1/16, 0, 1/16,
# 0, 0, ... ] for the 0th and n+1th block respectively.
# Actually, this is equivalent to just solving the simultaneous equation Ax=x
# where A is the matrix above. (Theorem of Stochastic Matrices)
# Note that this solution ignores the rules about replacement of CC/CH cards;
# in order to implement that you need to use 16*16*120=$BIGNUM states for the
# Markov process. This will be very slow to compute with.
use Math::Cephes::Matrix;

# Start by generating the dice roll matrix.
my $moves = [];
for(my $i=0; $i < 120; $i++) {
	for(my $j = 0; $j < 120; $j++) {
		my $fromsquare = $j % 40;
		my $tosquare = $i % 40;
		my $fromdoubles = int($j/40);
		my $todoubles = int($i/40);
		my $chance = 0;
		my $neededroll = ($tosquare - $fromsquare) % 40;
		if ($todoubles == 0
			&& $neededroll >= 3 && $neededroll <= 7) {
			# Anything but a double
			# Note that 2 and 8 are impossible rolls.
			my $ways = $neededroll - 1;
			$ways = 8 - $ways if $ways > 4;
			$ways-- if $neededroll % 2 == 0;
			$chance = $ways / 16;
		} elsif ($todoubles == $fromdoubles + 1 && $neededroll % 2 == 0
			&& $neededroll >= 2 && $neededroll <= 8 ) {
			# A double
			$chance = 1/16;
		} else {
			# Doubles can only increase by one or go to zero, so impossible.
			$chance = 0;
		}
		if ($fromdoubles == 2 && $todoubles == 0 && $tosquare == 10) {
			# We can go to jail due to overdoubling.
			$chance += 1/4;
		}
		$moves->[$i][$j] = $chance;
	}
}

# Now the specials. Identity in most columns.
my $special = [];
for(my $i=0; $i < 120; $i++) {
	for(my $j=0; $j < 120; $j++) {
		$special->[$i][$j] = $i == $j ? 1 : 0;
	}
}

# Community Chest
for my $add (0, 40, 80) {
	for(2, 17, 33) {
		$special->[$_+$add][$_+$add] = 14/16;
		$special->[10+$add][$_+$add] = 1/16;
		$special->[0+$add][$_+$add] = 1/16;
	}
}

# Chance
my %nextu = ( 7 => 12, 22 => 28, 36 => 12 );
my %nextr = ( 7 => 15, 22 => 25, 36 => 5 );
for my $add (0, 40, 80) {
	for(7, 22, 36) {
		$special->[$_+$add][$_+$add] = 6/16;
		$special->[0+$add][$_+$add] = 1/16;
		$special->[10+$add][$_+$add] = 1/16;
		$special->[11+$add][$_+$add] = 1/16;
		$special->[24+$add][$_+$add] = 1/16;
		$special->[37+$add][$_+$add] = 1/16;
		$special->[5+$add][$_+$add] = 1/16;
		$special->[$nextr{$_}+$add][$_+$add] += 2/16;
		$special->[$nextu{$_}+$add][$_+$add] += 1/16;
		$special->[$_-3+$add][$_+$add] = 1/16;
	}
	# Go to jail
	$special->[10+$add][30+$add] = 1;
	$special->[30+$add][30+$add] = 0;

}

$special = Math::Cephes::Matrix->new($special);
$moves = Math::Cephes::Matrix->new($moves);

$moves = $special->mul($moves);
# Calc moves^256
for(1..8) {
	$moves = $moves->mul($moves);
}

my $result = $moves->coef;
for(0..39) {
	my $sum = $result->[$_][0]+$result->[$_+40][0]+$result->[$_+80][0];
	push @a, [ $_, $sum ];
}

@a = sort { $b->[1] <=> $a->[1] } @a;
print "$a[0][0]$a[1][0]$a[2][0]\n";
