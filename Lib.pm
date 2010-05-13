package Lib;
use Math::BigInt;
require Exporter;
@EXPORT = qw(foldr foldl foldru foldlu sum product listinc_shortlex listinc_shortlex_increasing listinc_shortlex_strict_increasing listinc_lex listinc_lex_increasing listinc_lex_strict_increasing);

#Fold operations use global $a, $b as params.
# optimised foldl { $a + $_ } 0, @list
sub sum(@) {
	my $sum = 0;
	$sum += $_ for @_;
	return $sum;
}

# optimised foldl { $a * $_ }  1, @list
sub product(@) {
	my $product = 1;
	$product *= $_ for @_;
	return $product;
}

sub max(@) {
	my $max = $_[0];
	for(@_[1..$#_]) {
		$max = $_ if $_ > $max;
	}
	return $max;
}

sub min(@) {
	my $min = $_[0];
	for(@_[1..$#_]) {
		$max = $_ if $_ < $min;
	}
	return $min;
}

sub fibs() {
	my $a1 = 0;
	my $a2 = 1;
	return sub {
		$a2 = $a1 + $a2;
		$a1 = $a2 - $a1;
		return $a2;
	}
}

#my @primes;
#my @prime_seive;
#my $prime_seive_start;
#my $prime_seive_end;
#my $prime_seive_pos;
#sub primes() {
#	if (!$prime_seive_start) {
#		$prime_seive_start = 2;
#		$prime_seive_end = 1024;
#		$prime_seive_pos = 0;
#		@prime_seive = ((1) x ($prime_seive_end-$prime_seive_start+1));
#	}
#	my $i;
#	return sub {
#		return $primes[$i] if $i++ <= $#primes;
#		while(1) {
#			if ($prime_seive_pos > $#prime_seive) {
#				$prime_seive_start = $prime_seive_end + 1;
#				$prime_seive_end = 2 * $prime_seive_end;
#				$prime_seive_pos = 0;
#				@prime_seive = ((1) x ($prime_seive_end-$prime_seive_start+1));
#				for my $p (@primes) {
#					my $start = $prime_seive_start / $p;
#					$start = int $start + 1 if $start != int $start;
#					my $end = int($prime_seive_end / $p);
#					for(my $n = $start; $n <= $end; $n++) {
#						$prime_seive[$n*$p-$prime_seive_start] = 0;
#					}
#				}
#			}
#			if ($prime_seive[$prime_seive_pos]) {
#				my $p = $prime_seive_pos + $prime_seive_start;
#				my $start = $prime_seive_start / $p;
#				$start = int $start + 1 if $start != int $start;
#				my $end = int($prime_seive_end / $p);
#				for(my $n = $start; $n <= $end; $n++) {
#					$prime_seive[$n*$p] = 0;
#				}
#				push @primes, $p;
#				$prime_seive_pos++;
#				return $p;
#			}
#			$prime_seive_pos++;
#		}
#	}
#}

my @primes;
my $primes_fh;
sub primes() {
	my $i = -1;
	return sub {
		if (++$i <= $#primes) {
			return $primes[$i];
		}
		return next_prime();
	}
}

sub next_prime {
	if (!$primes_fh) {
		open $primes_fh, "primes 1|";
	}
	my $a = <$primes_fh>;
	chomp $a;
	push @primes, $a;
	return $a;
}

sub naturals {
	my $i = $_[0] ? $_[0] - 1 : 0;
	if ($_[1]) {
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

# These two return diagonal wedges
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
			if ($x*$x > $r2/2) {
				$r2++;
				$x = 0;
				next
			}
			$y = int(sqrt($r2 - $x*$x));
			if ($x*$x + $y*$y > $r2 - 1) {
				return [ $x, $y ];
			}
		}
	}
}

sub naturals2_radial_strict_increasing {
	return hgrep { $_->[0] != $_->[1] } naturals2_radial_increasing;
}


sub unique_prime_factors($) {
	my $i = $_[0];
	my $p = primes;
	my @f;
	while(my $f = $p->()) {
		if ($i % $f == 0) {
			push @f, $f;
			$i /= $f while $i % $f == 0;
		}
	}
	return @f;
}

sub prime_factors($) {
	my $i = $_[0];
	my $p = primes;
	my @f;
	while(my $f = $p->()) {
		while ($i % $f == 0) {
			push @f, $f;
			$i /= $f;
		}
	}
	return @f;
}

sub prime_power_factors($) {
	my $i = $_[0];
	my $p = primes;
	my @f;
	while(my $f = $p->()) {
		last if $i == 1;
		my $c = 0;
		while(my $f = $primes[$p++] || next_prime()) {
			++$c;
			$i /= $f;
		}
		push @f, $f**$c if $c;
	}
	return @f;
}

sub prime_factor_powers($) {
	my $i = $_[0];
	my $p = 0;
	my @f;
	while(my $f = $primes[$p++] || next_prime()) {
		last if $i == 1;
		my $c = 0;
		while ($i % $f == 0) {
			++$c;
			$i /= $f;
		}
		push @f, [$f, $c] if $c;
	}
	return @f;
}

sub divisors($) {
	my @div = prime_factor_powers $_[0];
	return product map { $_->[1] + 1 } @div;
}

sub common_prime_factor_powers(@) {
	my @f = prime_factor_powers(shift);
	for my $i (@_) {
		for(my $fn=0; $fn < @f; ++$fn) {
			my $f = $f[$fn][0];
			my $c = 0;
			while($i % $f == 0) {
				++$c;
				$i /= $f;
			}
			if ($c) {
				$f[$fn][1] = $c if $c < $f[$fn][1];
			} else {
				splice(@f, $fn, 1);
				--$fn;
			}
		}
	}
}

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
	my @a, @b;
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
		$ret = [$a[$p], $b[$s-$p]];
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
		$ret = [$a[$p], $a[$s-$p]];
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

sub hmap(&$) {
	my $filter = $_[0];
	my $source = $_[1];
	return sub {
		local $_ = $source->();
		return unless $_;
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

sub hjoin {
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
	return sub {
		return unless @arr;
		my $s;
		while(!defined($s = $arr[0]->())) {
			shift @arr;
			return unless @arr;
		}
		push @arr, shift @arr;
		return $s;
	}
}

sub promote {
	my @arr = @_;
	return sub {
		return shift @arr;
	}
}

sub flatten($) {
	my $s;
	my @ret;
	while(defined($s = $_[0]->())) {
		push @ret, $s;
	}
	return @ret;
}

sub last($) {
	my $s;
	my $ret;
	while(defined($s = $_[0]->())) {
		$ret = $s;
	}
	return $ret;
}

#f(...f(f(i, 0), 1), ..., n)
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
	for(my $i=2; $i<@_; ++$i) {
		$_ = $_[$i];
		$a = $_[0]->();
		last if $_[1]->($a);
	}
	return $a;
}

#f(0, f(1, ... f(n, i) ... ))
sub foldr(&$@) {
	local $a = $_[1];
	local $_;
	for(my $i=$#_; $i>=2; --$i) {
		$_ = $_[2][$i];
		$a = $_[0]->();
	}
	return $b;
}

sub foldru(&$@) {
	local $a = $_[2];
	local $_;
	for(my $i=$#_; $i>=2; --$i) {
		$_ = $_[$i];
		$a = $_[0]->();
		last if $_[1]->($a);
	}
	return $b;
}

# Counts over increasing lists using the short-lex ordering:
# (1) < (2) < ... < (0, 0) < (1, 3) < (2, 1) < ...
# It moves to the next size when f(list) is false for (n, 0, 0, ...)
# Optional scalar determines the minimum value to use. If can be a subref; if
# it is, it is passed the new list size.
sub listinc_shortlex_increasing(&@:$) {
	for(my $i=$#{$_[1]}; $i >= 0; --$i) {
		$_[1][$i]++;
		my $res = $_[0]->($_[1]);
		return $res if defined $res;
		if ($i > 0) {
			# We got too high, so try incrementing one back
			++$_[1][$i-1];
			for (my $j=$i; $j < @{$_[1]}; ++$j) {
				$_[1][$j] = $_[1][$j-1];
			}
			--$_[1][$i-1];
		}
	}
	my $start;
	if (@_ > 2) {
		if (ref $_[2]) {
			$start = $_[2]->(@{$_[1]} + 1);
			return unless defined $start;
		} else {
			$start = $_[2];
		}
	} else {
		$start = 0;
	}
	push @{$_[1]}, $start;
	for(my $i=0; $i<$#{$_[1]}; ++$i) {
		$_[1][$i] = $start;
	}
	my $res = $_[0]->($_[1]);
	return $res;
}

sub listinc_shortlex_strict_increasing(&@:$) {
	for(my $i=$#{$_[1]}; $i >= 0; --$i) {
		$_[1][$i]++;
		my $res = $_[0]->($_[1]);
		return $res if defined $res;
		if ($i > 0) {
			# We got too high, so try incrementing one back
			++$_[1][$i-1];
			for (my $j=$i; $j < @{$_[1]}; ++$j) {
				$_[1][$j] = $_[1][$j-1] + 1;
			}
			--$_[1][$i-1];
		}
	}
	my $start;
	if (@_ > 2) {
		if (ref $_[2]) {
			$start = $_[2]->(@{$_[1]} + 1);
			return unless defined $start;
		} else {
			$start = $_[2];
		}
	} else {
		$start = 0;
	}
	push @{$_[1]}, $start + $#{$_[1]};
	for(my $i=0; $i<@{$_[1]}; ++$i) {
		$_[1][$i] = $start + $i;
	}
	my $res = $_[0]->($_[1]);
	return $res;
}

# Same as above, but loops over all lists whose lowest element is $_[2].
sub listinc_shortlex(&@:$) {
	for(my $i=$#{$_[1]}; $i >= 0; --$i) {
		$_[1][$i]++;
		my $res = $_[0]->($_[1]);
		return $res if defined $res;
		if ($i > 0) {
			# We got too high, so try incrementing one back
			for (my $j=$i; $j < @{$_[1]}; ++$j) {
				my $start;
				if (@_ > 2) {
					if (ref $_[2]) {
						$start = $_[2]->(scalar @{$_[1]}, $j);
					} else {
						$start = $_[2];
					}
				} else {
					$start = 0;
				}
				$_[1][$j] = $start;
			}
		}
	}
	if (@_ > 2) {
		if (ref $_[2]) {
			$start = $_[2]->(@{$_[1]} + 1, scalar @{$_[1]});
			return unless defined $start;
		} else {
			$start = $_[2];
		}
	} else {
		$start = 0;
	}
	push @{$_[1]}, $start;
	for(my $i=0; $i<$#{$_[1]}; ++$i) {
		if (@_ > 2) {
			if (ref $_[2]) {
				$start = $_[2]->(scalar @{$_[1]}, $i);
				return unless defined $start;
			} else {
				$start = $_[2];
			}
		} else {
			$start = 0;
		}
		$_[1][$i] = $start;
	}
	my $res = $_[0]->($_[1]);
	return $res;
}

# This loops over all lists in lexical order. It will grow the list until adding
# a new element makes f(list) false.
# (1) < (1, 1) < (1, 1, 1) < ... < (1, 2) < (2) < ...
# Assumption is that f(list, extra) is false if f(list) is false.
sub listinc_lex_increasing(&@) {
	# Try adding a new element.
	push @{$_[1]}, $_[1][$#{$_[1]}];
	my $res = $_[0]->($_[1]);
	return $res if defined $res;

	# No good. We got too long.
	# Suppose we came in with (@l, $r, $s). We next try (@l, $r, $s+1), then
	# (@l, $r+1) and so on.
	pop @{$_[1]};
	while(@{$_[1]}) {
		$_[1][$#{$_[1]}]++;
		$res = $_[0]->($_[1]);
		return $res if defined $res;
		# Still too long.
		pop @{$_[1]};
	}
	# If we got here, we emptied the list, so have covered the whole allowable
	# space.
	return;
}

# Strictly increasing lists
sub listinc_lex_strict_increasing(&@) {
	# Try adding a new element.
	push @{$_[1]}, $_[1][$#{$_[1]}]+1;
	my $res = $_[0]->($_[1]);
	return $res if defined $res;

	# No good. We got too long.
	# Suppose we came in with (@l, $r, $s). We next try (@l, $r, $s+1), then
	# (@l, $r+1) and so on.
	pop @{$_[1]};
	while(@{$_[1]}) {
		$_[1][$#{$_[1]}]++;
		$res = $_[0]->($_[1]);
		return $res if defined $res;
		# Still too long.
		pop @{$_[1]};
	}
	# If we got here, we emptied the list, so have covered the whole allowable
	# space.
	return;
}

# Same as above, but for all lists.
sub listinc_lex(&@:$) {
	my $start;
	if (@_ > 2) {
		if (ref $_[2]) {
			$start = $_[2]->(scalar @{$_[1]});
		} else {
			$start = $_[2];
		}
	} else {
		$start = 0;
	}

	# Try adding a new element.
	if (defined $start) {
		push @{$_[1]}, $start;
		my $res = $_[0]->($_[1]);
		return $res if defined $res;
	}

	# No good. We got too long.
	# Suppose we came in with (@l, $r, $s). We next try (@l, $r, $s+1), then
	# (@l, $r+1) and so on.
	pop @{$_[1]};
	while(@{$_[1]}) {
		$_[1][$#{$_[1]}]++;
		$res = $_[0]->($_[1]);
		return $res if defined $res;
		# Still too long.
		pop @{$_[1]};
	}
	# If we got here, we emptied the list, so have covered the whole allowable
	# space.
	return;
}

sub is_prime {
	my $test = $_[0];
	my $lim = sqrt($test);
	for(@primes) {
		return 1 if $_ >= $lim;
		return if $test % $_ == 0;
	}
	while(my $p = next_prime()) {
		return 1 if $p >= $lim;
		return if $test % $p == 0;
	}
}

sub is_triangle {
	my $pot = sqrt(1+8*$_[0]);
	return $pot == int $pot && $pot % 2;
}

sub is_palindrome {
	my $x = substr($_[0], 0, int(length($_[0])/2));
	$x = join '', reverse split //, $x;
	return $x eq substr($_[0], -int(length($_[0])/2));
}

sub is_pandigital_1 {
	my $val = $_[0];
	my $len = length $val;
	my $count = $len;
	my @digits;
	while($count--) {
		return if $digits[$val%10];
		$digits[$val%10]=1;
		$val = int($val/10);
	}
	return $#digits == $len;
}

our %roman_val = (
	I => 1,
	V => 5,
	X => 10,
	L => 50,
	C => 100,
	D => 500,
	M => 1000,
);
# This /assumes/ the numerals are written according to the validity rules.
# Output is undefined if it's not.
sub read_legit_roman($) {
	my ($x) = @_;
	my @digits = split //, $x;
	my $runningtotal;
	for(my $i = 0; $i < @digits; $i++) {
		if ($i < $#digits && $roman_val{$digits[$i]} < $roman_val{$digits[$i+1]}) {
			$runningtotal -= $roman_val{$digits[$i]};
		} else {
			$runningtotal += $roman_val{$digits[$i]};
		}
	}
	return $runningtotal;
}

sub minimal_roman($) {
	my $x = $_[0];
	my $out = '';
	roman_nom($x, $out, 1000, 'M');
	roman_nom($x, $out, 900, 'CM');
	roman_nom($x, $out, 500, 'D');
	roman_nom($x, $out, 400, 'CD');
	roman_nom($x, $out, 100, 'C');
	roman_nom($x, $out, 90, 'XC');
	roman_nom($x, $out, 50, 'L');
	roman_nom($x, $out, 40, 'XL');
	roman_nom($x, $out, 10, 'X');
	roman_nom($x, $out, 9, 'IX');
	roman_nom($x, $out, 5, 'V');
	roman_nom($x, $out, 4, 'IV');
	roman_nom($x, $out, 1, 'I');
	return $out;
}

sub roman_nom {
	while($_[0] >= $_[2]) {
		$_[0] -= $_[2];
		$_[1] .= $_[3];
	}
}

sub sum_digits($) {
	my $temp = $_[0];
	my $sum = 0;
	while($temp > 0) {
		$sum += $temp % 10;
		$temp /= 10;
	}
	return $sum;
}

sub hcf($$) {
	my $a = $_[0];
	my $b = $_[1];
	($a, $b) = ($b, $a) if $b > $a;
	return $a if $a == $b;
	while($b > 0) {
		($a, $b) = ($b, $a % $b);
	}
	return $a;
}

sub lcm($$) {
	return $_[0] * $_[1] / hcf($_[0], $_[1]);
}

# Use Euclid's forumula to generate an infinite list.
sub primitive_pythagorean_triples {
	my $nm = naturals2_radial_strict_increasing;
	return sub {
		my ($m, $n);
		while(($n, $m) = @{$nm->()}) {
			next if ($n + $m) % 2 == 0;
			next if hcf($n, $m) != 1;
			my $c = $n**2 + $m**2;
			my $b = $m**2 - $n**2;
			my $a = 2 * $m * $n;
			($a, $b) = ($b, $a) if $a > $b;
			return [ $a, $b, $c ];
		}
	}
}

# Multiply everything in the above lists by naturals.
sub pythagorean_triples {
	return hmap { [ $_->[0][0] * $_->[1], $_->[0][1] * $_->[1], $_->[0][2] * $_->[1] ] } hcross_diagonal primitive_pythagorean_triples, naturals;
}

my @fac = (1);
sub fac {
	return $fac[$_[0]] if defined $fac[$_[0]];
	return $fac[$_[0]] = $_[0] * fac($_[0]-1);
}

sub ncr {
	my ($n, $r) = @_;
	$r = $n - $r if 2 * $r > $n;
	my $p = 1;
	for(1..$r) {
		$p *= ($n-$r+$_)/$_;
	}
	return $p;
}

sub alldivisors {
	my ($n) = @_;
	my @divisors = [], [], map { [1] } 2..$n;
	for my $div (1..int($n/2)) {
		for(my $mul=2; $mul*$div <= $n; $mul++) {
			push @{$divisors[$mul*$div]}, $div;
		}
	}
	return @divisors;
}

1;
