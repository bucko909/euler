# We use two routines.
# One looks for subsets of size n which exist in n boxes: If n boxes can
# contain only numbers from a set of size n, all members of that set must be in
# those boxes and can be eliminated from the remainder.
# For example, [ [2, 3], [3, 4], [2, 4], [2, 3, 4, 5, 6] ]
#          ->  [ [2, 3], [3, 4], [2, 4], [5, 6] ]
# One attempts to find ways to place a digit. If there's only one, it is placed.
# This could be extended to groups of digits, too, but I couldn't be bothered.
# For example (groups), [ [2, 3, 4], [2, 4, 5], [3, 4, 7], [5, 6, 7] ]
#                    -> [ [2, 3], [2, 4], [3, 4], [5, 6, 7] ]
# (assuming no other entries have any of (2, 3, 4)).
# Note that the latter approach is actually part of the former. For example, if
# a single digit exists in only one sqaure, the remaining n-1 squares have only
# n-1 possibilities, so the former will pick it up. However, adding it seems to
# improve speed, so I reduced the checks on the first one to not intersect.
# Once repeated application of the above yeilds no new information, we pick a
# random square and set it equal to a random possibility and try to infer
# a solution or a contradiction.
use Lib;
use strict;
use warnings;

sub elimination {
	my ($contents) = (@_);
	my @ret;
	my @list;
	# Sample is the current set of things we're not too sure about.
	my @sample = @$contents;
	# Mappings is a map from sample index -> contents index
	my @mappings = (0..8);
	# Invalid[i] is true if i can't be in sample. 
	my @invalid = ((0) x 10);
	# Ret is our return value.
	my $ret = 0;
	while(1) {
		last unless @sample;
		Lib::listinc_shortlex_strict_increasing {
			return if @{$_[0]} >= $#sample - 1;
			return if $_[0][$#{$_[0]}] > $#sample;
			return 1;
		} \@list;
		last if @list >= $#sample - 1;

		# Find the set of all things set by this subset.
		my @set = ((0) x 10);
		for (@list) {
			$set[$_] = 1 for @{$sample[$_]};
		}

		my $total = Lib::sum @set;
		# If there's more numbers than spots we can make no inference.
		next if $total > @list;
		# If there's less numbers than spots, the puzzle cannot be completed.
		return if $total < @list;

		# OK, if we got here we need to tear out the subset
		for(0..$#list) {
			splice @sample, $list[$_] - $_, 1;
			splice @mappings, $list[$_] - $_, 1;
		}

		# Next we add everything to the invalid mappings.
		for(1..9) {
			$invalid[$_] ||= $set[$_];
		}

		# Now for the remainder we must remove all invalid entries.
		for(@sample) {
			my $was = scalar @$_;
			splice @$_, 0, scalar @$_, grep { !$invalid[$_] } @$_;
			return unless @$_;
			$ret = 1 if $was != @$_;
		}
		@list = ();
	}
	return $ret;
}

# Redundant!
sub place {
	my ($contents) = @_;
	my $ret = 0;
	for my $num (1..9) {
		my @poss = grep { my @a = grep { $_ == $num } @{$contents->[$_]}; scalar @a } (0..8);
		if (@poss == 1 && @{$contents->[$poss[0]]} > 1) {
			splice @{$contents->[$poss[0]]}, 0, @{$contents->[$poss[0]]}, $num;
			$ret = 1;
		} elsif (@poss == 0) {
			return;
		}
	}
	return $ret;
}

sub do_elimination {
	my ($puzzle) = @_;
	my $ret = 0;
	# rows
	for my $row (0..8) {
		my $thisret = elimination( $puzzle->[$row] );
		return if !defined $thisret;
		$ret ||= $thisret;
		$thisret = place( $puzzle->[$row] );
		return if !defined $thisret;
		$ret ||= $thisret;
	}
	# cols
	for my $col (0..8) {
		my @col = map { $puzzle->[$_][$col] } (0..8);
		my $thisret = elimination( \@col );
		return if !defined $thisret;
		$ret ||= $thisret;
		$thisret = place( \@col );
		return if !defined $thisret;
		$ret ||= $thisret;
	}
	# squares
	for my $square ( map { [0, $_], [1, $_], [2, $_] } (0..2) ) {
		my @square = map {
			$puzzle->[$_+3*$square->[0]][0+3*$square->[1]],
			$puzzle->[$_+3*$square->[0]][1+3*$square->[1]],
			$puzzle->[$_+3*$square->[0]][2+3*$square->[1]],
		} (0..2);
		my $thisret = elimination( \@square );
		return if !defined $thisret;
		$ret ||= $thisret;
		$thisret = place( \@square );
		return if !defined $thisret;
		$ret ||= $thisret;
	}
	return $ret;
}

sub solved {
	my ($puzzle) = @_;
	for my $row (0..8) {
		for my $col (0..8) {
			return if @{$puzzle->[$row][$col]} != 1;
		}
	}
	return 1;
}

sub solve {
	my ($puzzle) = @_;
	while(1) {
		my $ret = do_elimination($puzzle);
		print "Post-elim:\n";
		for(@$puzzle) {
			print "".join('',map{"[".join('',@$_)."]"}@$_)."\n";
		}
		return if !defined $ret;
		last if !$ret;
	}
	if (solved($puzzle)) {
		for(@$puzzle) {
			print "".join('',map{join('',@$_)}@$_)."\n";
		}
		return $puzzle->[0][0][0].$puzzle->[0][1][0].$puzzle->[0][2][0];
	}

	# Guess the first non-solved entry.
	for my $row (0..8) {
		for my $col (0..8) {
			if (@{$puzzle->[$row][$col]} > 1) {
				for(@{$puzzle->[$row][$col]}) {
					my $newpuzzle = copy($puzzle);
					# Guessing ($row, $col) is $_
		print "Stalemate at:\n";
		for(@$puzzle) {
			print "".join('',map{"[".join('',@$_)."]"}@$_)."\n";
		}
		print "Guessing $row,$col = $_\n";
					$newpuzzle->[$row][$col] = [ $_ ];
					my $ret = solve($newpuzzle);
					return $ret if defined $ret;
				}
				# Puzzle is completely impossible.
				return;
			}
		}
	}
}

sub copy {
	my ($puzzle) = @_;
	my $newpuzzle = [ ];
	for my $row (0..8) {
		for my $col (0..8) {
			$newpuzzle->[$row][$col] = [ @{$puzzle->[$row][$col]} ];
		}
	}
	return $newpuzzle;
}

sub fixup {
	my ($puzzle) = @_;
	for my $row (0..8) {
		for my $col (0..8) {
			if ($puzzle->[$row][$col] == 0) {
				$puzzle->[$row][$col] = [ 1..9 ];
			} else {
				$puzzle->[$row][$col] = [ $puzzle->[$row][$col] ];
			}
		}
	}
}

open SUDOKU, "sudoku_times_140310.txt";
my $total = 0;
while($_ = <SUDOKU>) {
	my @puzzle;
	for(1..9) {
		my $line = <SUDOKU>;
		$line =~ s/\s//g;
		push @puzzle, [ split //, $line ];
	}
	fixup(\@puzzle);
	my $ret = solve(\@puzzle);
	if ($ret) {
		$total += $ret;
	} else {
		print "Error\n";
		exit;
	}
}
close SUDOKU;
print "$total\n";
