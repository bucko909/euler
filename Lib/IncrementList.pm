package Lib;
use strict;
use warnings;

# Counts over increasing lists using the short-lex ordering:
# (1) < (2) < ... < (0, 0) < (1, 3) < (2, 1) < ...
# It moves to the next size when f(list) is false for (n, 0, 0, ...)
# Optional scalar determines the minimum value to use. If can be a subref; if
# it is, it is passed the new list size.
sub lists($$$@) {
	my ($incrementor, $initialiser, $test_valid, @current) = @_;
	my @test_valid;
	if (!$test_valid) {
	} elsif (ref $test_valid eq 'ARRAY') {
		@test_valid = @$test_valid;
	} else {
		@test_valid = ($test_valid);
	}
	return sub {
		return unless $incrementor;
		my $ret = [ @current ];
		my $n;
		undef $Lib::val;
		while(!$Lib::val) {
			# Let the incrementor find the next n
			$n = $incrementor->(\@current, $initialiser, $n);
			if (!defined $n) {
				# Can't increment; drop out.
				undef $incrementor;
				undef $initialiser;
				undef $test_valid;
				@current = ();
				last;
			}
			if (@test_valid) {
				for my $fn (@test_valid) {
					$Lib::val = $fn->($n, \@current);
					last if !defined $Lib::val;
				}
			} else {
				$Lib::val = 1;
			}
		}
		return $ret;
	};
}

# lex likes to extend before incrementing.
sub incrementor_lex() {
	return sub {
		my ($list, $initialiser, $n) = @_;
		if (!defined $n) {
			# If $n is 0, we assume we can extend.
			push @$list, 0;
			my $add = eval { $initialiser->($#$list, $list) };
			if ($@) {
				pop @$list;
				return incrementor_lex($list, $initialiser, $n);
			}
			$list->[$#$list] = $add;
			return scalar $#$list;
		} else {
			# Otherwise, we increment the final value, shortening the list
			# first (it was already lengthened before).
			return unless @$list > 1;
			pop @$list;
			$list->[$#$list]++;
			return scalar $#$list;
		}
	};
}

# short_lex likes to increment before extending
sub incrementor_short_lex() {
	my $state;
	return sub {
		my ($list, $initialiser, $n) = @_;
		my $l = $#$list;
		if (!defined $n) {
			$n = $l;
			$state = 0;
		} else {
			$n--;
		}
		if ($n >= 0 && $state == 0) {
			# Increment value l-n and initialise the rest.
			$list->[$n]++;
			eval {
				$list->[$_] = $initialiser->($_, $list) for ($n+1..$l);
			};
			if ($@) {
				return incrementor_short_lex($list, $initialiser, $n-1);
			}
			return $n;
		} elsif ($n == -1) {
			# Extend the list and initialise everything.
			return if $state == 1;
			$state = 1;
			$list->[$l+1] = 0;
			eval {
				$list->[$_] = $initialiser->($_, $list) for(0..$l+1);
			};
			return if $@;
			return $l+1; # Don't allow two extensions in a row.
		}
		return;
	};
}

# Walk over increasing lists.
sub initialiser_increasing($) {
	my ($start) = @_;
	return sub {
		return $start if $_[0] == 0;
		return $_[1][$_[0]-1];
	}
}

# Walk over strictly increasing lists.
sub initialiser_strictly_increasing($) {
	my ($start) = @_;
	return sub {
		return $start if $_[0] == 0;
		return $_[1][$_[0]-1] + 1;
	}
}

# Walk over decreasing lists. Needs a test, too.
sub initialiser_decreasing($) {
	my ($min) = @_;
	return sub {
		return $min;
	}
}

# Walk over strictly decreasing lists. Needs a test, too.
sub initialiser_strictly_decreasing($) {
	my ($min) = @_;
	return sub {
		return $min + $#{$_[1]} - $_[0];
	}
}

# Check if a just-inc list is decreasing.
sub test_decreasing($) {
	my ($min) = @_;
	return sub {
		return 1 if $_[0] == 0;
		return $_[1][$_[0]] <= $_[1][$_[0]-1] ? 1 : undef;
	}
}

# Check if a just-inc list is decreasing.
sub test_strictly_decreasing($) {
	my ($min) = @_;
	return sub {
		return 1 if $_[0] == 0;
		return $_[1][$_[0]] < $_[1][$_[0]-1] ? 1 : undef;
	}
}

1;
