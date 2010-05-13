package Lib;
use strict;
use warnings;

sub recurrence_eval {
	my ($coeff, $val, $cache) = @_;
	if ($cache && defined $cache->[$val]) {
		return $cache->[$val];
	}
	my $sum = 0;
	for (1..@$coeff) {
		$sum += $coeff->[$_-1] * recurrence_eval($coeff, $val - $_, $cache);
	}
	return $cache->[$val] = $sum;
}

sub recurrence_curry {
	my ($coeff, $cache) = @_;
	return sub {
		return recurrence_eval($coeff, $_[0], $cache);
	}
}

# When solving for T(2n) = f(T(n), T(n+1), ..., T(n+k)) note that:
# k is less than or equal to #coef - 1 (otherwise, find a new f with that
# range)
#
# Since T(n) is asymptotic to j^n for some j, T(2n) is asymptotic to j^2n
#
# Thus f is quadratically bounded in the T(i).
sub recurrence_to_log_eval {
	my ($coeff, $cache, $modulo) = @_;
	my $min_n = @$coeff;
	my @target_0;
	my @target_1;
	my @rows;
	for my $add (0..@$coeff*(@$coeff+5)/2) {
		push @target_0, recurrence_eval($coeff, ($min_n+$add)*2, $cache);
		push @target_1, recurrence_eval($coeff, ($min_n+$add)*2+1, $cache);
		my @row;
		push @row, 1;
		for my $f (0..$#$coeff) {
			push @row, recurrence_eval($coeff, $min_n+$add+$f, $cache);
			for my $l ($f..$#$coeff) {
				push @row, recurrence_eval($coeff, $min_n+$add+$f, $cache)
					* recurrence_eval($coeff, $min_n+$add+$l, $cache);
			}
		}
		push @rows, \@row;
	}
	my $v_0 = solve_simultaneous(\@target_0, @rows);
	my $v_1 = solve_simultaneous(\@target_1, @rows);
	my %cache2;
	my $a;
	$a = sub {
		my ($v) = @_;
		return $cache->[$_] if defined $cache->[$_];
		return $cache2{$_} if defined $cache2{$_};
		my $sum = 0;
		my @bits = $v % 2 == 0 ? @$v_0 : @$v_1;
		my $val = int($v/2);
		$sum += shift @bits;
		for my $f (0..$#$coeff) {
			$sum += $a->($val+$f) * shift @bits;
			for my $l ($f..$#$coeff) {
				$sum += $a->($val+$f) * $a->($val+$l) * shift @bits;
			}
		}
		if ($modulo) {
			return $cache2{$v} = ($sum % $modulo);
		} else {
			return $cache2{$v} = $sum;
		}
	};
	return sub {
		%cache2 = ();
		return $a->($_[0]);
	}
}

1;
