package Lib;
use Lib::Lists;
use strict;
use warnings;

# Basic lists

sub promote(@) {
	my @arr = @_;
	return sub {
		return shift @arr;
	}
}

sub iterate(&$) {
	my $f = $_[0];
	my $v = $_[1];
	return sub {
		my $ret = $v;
		local $_ = $v;
		$v = $f->();
		return $ret;
	}
}

sub naturals {
	my $i = $_[0] ? $_[0] - 1 : 0;
	if (defined $_[1]) {
		my $l = $_[1];
		return sub {
			return if $i >= $l;
			return ++$i;
		}
	} else {
		return sub {
			return ++$i;
		}
	}
}

sub integers {
	my $s = 1;
	my $i = 0;
	return sub {
		$i++ if $s == -1;
		$s *= -1;
		return $s * $i;
	}
}

sub naturals2_diagonal_increasing {
	my $sum = 2;
	my $x = 1;
	return sub {
		my $ret = [ $sum - $x, $x ];
		$x++;
		if ($x >= $sum) {
			$sum++;
			$x = int(($sum+1)/2);
		}
		return $ret;
	}
}

sub naturals2_diagonal_strict_increasing {
	return hgrep { $_->[0] != $_->[1] } naturals2_diagonal_increasing;
}

sub naturals2_radial_increasing {
	my $r2 = 2;
	my $x = 0;
	return sub {
		my $y;
		while(1) {
			$x++;
			my $x2 = $x*$x;
			if ($x2 > $r2/2) {
				$r2++;
				$x = $x2 = 0;
				next
			}
			$y = int(sqrt($r2 - $x2));
			if ($x2 + $y*$y > $r2 - 1) {
				return [ $x, $y ];
			}
		}
	}
}

sub naturals2_radial_strict_increasing {
	return hgrep(sub { $_->[0] != $_->[1] }, naturals2_radial_increasing);
}

# List processing

sub hgrep(&$) {
	my $filter = $_[0];
	my $source = $_[1];
	return sub {
		local $_;
		while(defined($_ = $source->())) {
			return $_ if $filter->();
		}
		return undef;
	}
}

sub hmap(&$) {
	my $filter = $_[0];
	my $source = $_[1];
	return sub {
		local $_ = $source->();
		return unless defined $_;
		return $filter->();
	}
}

sub htake($$) {
	my $length = $_[0];
	my $source = $_[1];
	return sub {
		if ($length > 0) {
			$length--;
			return $source->();
		}
		return;
	}
}

sub hclip(&$) {
	my $filter = $_[0];
	my $source = $_[1];
	return sub {
		if ($filter) {
			local $_ = $source->();
			if ($filter->()) {
				return $_;
			}
			$filter = undef;
		}
		return;
	}
}

# List combinators

# Returns ($_[0][0], $_[1][0]), ($_[0][1], $_[1][1]), ...
sub hzip($$) {
	my ($a, $b) = @_;
	return sub {
		if ($a) {
			my $av = $a->();
			my $bv = $b->();
			if (defined $av && defined $bv) {
				return [ $av, $bv ];
			}
			$a = $b = undef;
			return undef;
		} else {
			return undef;
		}
	}
}

# Consecutive terms
sub hconsec($) {
	my ($a) = @_;
	my $last = $a->();
	return sub {
		my $new = $a->();
		return unless $a;
		my $ret = [ $last, $new ];
		$last = $new;
		return $ret;
	}
}

# Finite sets only...
sub hcross($$) {
	my ($a, $b) = @_;
	my $x = $a->();
	my @b = ($b->());
	return if !defined $x || !defined $b[0];
	my $i = -1;
	return sub {
		my $ret = undef;
		if ($i >= 0) {
			$ret = [$x, $b[$i]];
			if (++$i == @b) {
				$i = 0;
				$x = $a->();
				if (!defined $x) {
					$i = -2;
					@b = ();
				}
			}
		} elsif ($i == -1) {
			$ret = [$x, $b[$#b]];
			my $tmp = $b->();
			if (!$tmp) {
				$i = 0;
				$x = $a->();
				if (!defined $x) {
					$i = -2;
					@b = ();
				}
			} else {
				push @b, $tmp;
			}
		}
		return $ret;
	};
}

# hcross($_[0], $_[0]) (were it to work), but only passes each unordered pair
# once
sub hwedge($) {
	my ($a) = @_;
	my $x = $a->();
	my @b = ($x);
	return if !defined $x;
	my $i = 0;
	return sub {
		my $ret = undef;
		if ($i == $#b) {
			$ret = [$x, $b[$#b]];
			$i = 0;
			$x = $a->();
			if (!defined $x) {
				$i = -2;
				@b = ();
			} else {
				push @b, $x;
			}
		} elsif ($i >= 0) {
			$ret = [$x, $b[$i]];
			$i++;
		}
		return $ret;
	};
}

# ~ works for infinite sets, but grows in memory required.
sub hcross_diagonal($$) {
	my ($a, $b) = @_;
	my $s = 0;
	my $p = 0;
	my (@a, @b);
	{
		my $tmp = $a->();
		return unless $tmp;
		@a = ($tmp);
		$tmp = $b->();
		return unless $tmp;
		@b = ($tmp);
	}
	return sub {
		return unless @a;
		my $ret = [$a[$p], $b[$s-$p]];
		++$p;
		if ($p>$s||$p>$#a) {
			++$s;
			my $ta = @a;
			if (@a>=@b) {
				my $tmp = $a->();
				push @a, $tmp if $tmp;
			}
			if (@b>=$ta) {
				my $tmp = $b->();
				push @b, $tmp if $tmp;
			}
			if($#b<$s) {
				$p = $s-$#b;
			} else {
				$p = 0;
			}
			if ($s>$#a+$#b) {
				@a = ();
				@b = ();
			}
		}
		return $ret;
	}
}

# hcross_diagonal($_[0], $_[0]) (were it to work), but only passes each
# unordered pair once
sub hwedge_diagonal($) {
	my ($a) = @_;
	my $s = 0;
	my $p = 0;
	my @a;
	{
		my $tmp = $a->();
		return unless $tmp;
		@a = ($tmp);
	}
	return sub {
		return unless @a;
		my $ret = [$a[$p], $a[$s-$p]];
		++$p;
		if ($p>$s/2||$p>$#a) {
			++$s;
			if ($s==@a) {
				# Still stuff left.
				my $tmp = $a->();
				push @a, $tmp if $tmp;
			}
			$p = $s-$#a;
			if ($s>2*$#a) {
				@a = ();
			}
		}
		return $ret;
	}
}

sub hconcatenate {
	my @arr = @_;
	return sub {
		return unless @arr;
		my $s;
		while(!defined($s = $arr[0]->())) {
			shift @arr;
			return unless @arr;
		}
		return $s;
	}
}

sub hinterleave {
	my @arr = @_;
	my $p = 0;
	return sub {
		return unless @arr;
		my $s;
		$p = 0 if $p >= @arr;
		while(!defined($s = $arr[$p++]->())) {
			splice @arr, $p-1, 1;
			$p--;
			return unless @arr;
		}
		return $s;
	}
}

# List consumers

sub flatten($) {
	my $s;
	my @ret;
	while(defined($s = $_[0]->())) {
		push @ret, $s;
	}
	return @ret;
}

sub hlast($) {
	my $s;
	my $ret;
	while(defined($s = $_[0]->())) {
		$ret = $s;
	}
	return $ret;
}

#f(...f(f(i, a0), a1), ..., an)
sub foldl(&$@) {
	local $_ = $_[1];
	for(my $i=2; $i<@_; ++$i) {
		$_ = $_[0]->($_[$i]);
	}
	return $a;
}

sub foldlu(&&$@) {
	local $a = $_[2];
	local $_;
	for(my $i=3; $i<@_; ++$i) {
		$_ = $_[0]->($_[$i]);
		last if $_[1]->($a);
	}
	return $a;
}

1;
