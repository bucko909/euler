package Lib;
use Lib::Utils;
use Lib::IncrementList;
use strict;
use warnings;

sub gcd {
	my ($a, $b) = @_;
	while($b != 0) {
		($a, $b) = ($b, $a % $b);
	}
	return $a;
}

sub gcd_coefficients {
	my ($a, $b) = @_;
	my @bits;
	while($b != 0) {
		push @bits, int($a/$b);
		($a, $b) = ($b, $a % $b);
	}
	my ($cb, $ca) = (1, 0);
	for(my $i=$#bits-1; $i>=0; $i--) {
		($cb, $ca) = ($ca - $bits[$i] * $cb, $cb);
	}
	return ($a, $ca, $cb);
}

our @primes = (2, 3, 5, 7, 11, 13, 17);
our @prime_seive = ();
our $prime_seive_start = 9;
our $prime_seive_end = 9;
our $prime_seive_pos = 0;

sub primes() {
	my $i = 0;
	return sub {
		return $primes[$i++] if $i <= $#primes;
		$i++;
		return next_prime();
	}
}

sub next_prime() {
	my $size = $prime_seive_end;
	#$size = 100000 if $size > 100000;
	$prime_seive_start = $prime_seive_end + 1;
	$prime_seive_end = $prime_seive_end + $size;
	$prime_seive_pos = 0;
	@prime_seive = ((1) x ($prime_seive_end-$prime_seive_start+1));
	#my $max_prime_needed = int(sqrt($prime_seive_end));
	my $max_prime_needed = int(sqrt(2*$prime_seive_end-1));
	my $real_start = 2*$prime_seive_start-1;
	for my $p (@primes[1..$#primes]) {
		last if $p > $max_prime_needed;
		my $np = ($p-1)>>1;
		# start_offset is guaranteed odd
		my $start_offset;
		if ($real_start % $p == 0) {
			$start_offset = 0;
		} else {
			$start_offset = $p * (int($real_start/$p) % 2 + 1) - $real_start % $p;
		}
		my $start = int(($start_offset + 1) / 2);
		#print "$p from $real_start ($prime_seive_start) -> skip $start_offset ($start)\n";
		my $end = $#prime_seive;
		for(my $n = $start; $n <= $end; $n += $p) {
			$prime_seive[$n] = 0;
		}
	}
	my $pos = @primes;
	while($prime_seive_pos <= $#prime_seive) {
		if ($prime_seive[$prime_seive_pos]) {
			push @primes, 2*($prime_seive_pos + $prime_seive_start)-1;
		}
		$prime_seive_pos++;
	}
	return $primes[$pos];
}

sub unique_prime_factors($) {
	my $i = $_[0];
	$i = -$i if $i < 0;
	return if $i <= 1;
	my $pno = 0;
	my @f;
	while(my $f = ($primes[$pno++] || next_prime())) {
		if ($i % $f == 0) {
			push @f, $f;
			while ($i % $f == 0) {
				$i /= $f
			}
		}
		last if $f*$f > $i;
	}
	return @f;
}

sub prime_factors($) {
	my $i = $_[0];
	$i = -$i if $i < 0;
	return if $i <= 1;
	my $pno = 0;
	my @f;
	while(my $f = ($primes[$pno++] || next_prime())) {
		while ($i % $f == 0) {
			push @f, $f;
			$i /= $f;
		}
		last if $f*$f > $i;
	}
	return @f;
}

sub prime_power_factors($) {
	my $i = $_[0];
	$i = -$i if $i < 0;
	return if $i <= 1;
	my $pno = 0;
	my @f;
	while(my $f = ($primes[$pno++] || next_prime())) {
		if ($i % $f == 0) {
			my $c = 0;
			while($i % $f == 0) {
				++$c;
				$i /= $f;
			}
			push @f, $f**$c;
			last if $i == 1;
		}
	}
	return @f;
}

sub prime_factor_powers($) {
	my $i = $_[0];
	$i = -$i if $i < 0;
	return if $i <= 1;
	my $m = sqrt($i);
	my $pno = 0;
	my @f;
	while(my $f = ($primes[$pno++] || next_prime())) {
		if ($i % $f == 0) {
			my $c = 0;
			while($i % $f == 0) {
				++$c;
				$i /= $f;
			}
			push @f, [ $f, $c ];
			last if $i == 1;
		}
		if ($f > $m) {
			push @f, [$i, 1];
			last;
		}
	}
	return @f;
}

sub number_factors($) {
	my @div = prime_factor_powers $_[0];
	return product map { $_->[1] + 1 } @div;
}

sub common_prime_factor_powers(@) {
	my @f = prime_factor_powers(shift);
	for my $i (@_) {
		for(my $fn=0; $fn < @f; ++$fn) {
			my $f = $f[$fn][0];
			if ($i % $f == 0) {
				my $c = 0;
				while($i % $f == 0) {
					++$c;
					$i /= $f;
				}
				$f[$fn][1] = $c if $c < $f[$fn][1];
			} else {
				splice(@f, $fn, 1);
				--$fn;
			}
		}
	}
}

sub divisors($) {
	my @f = reverse prime_factor_powers($_[0]);
	my $l = Lib::lists Lib::incrementor_short_lex,
		sub { 0 },
		sub {
			@{$_[1]} == @f
			&& $_[1][$_[0]] <= $f[$_[0]][1]
		}, ((0) x @f);
	return sub {
		my $a;
		return unless $a = $l->();
		my $p = 1;
		$p *= $f[$_][0]**$a->[$_] for 0..$#f;
		return $p;
	}
}

sub square_divisors($) {
	my @f = reverse prime_factor_powers($_[0]);
	my $l = Lib::lists Lib::incrementor_short_lex,
		sub { 0 },
		sub {
			@{$_[1]} == @f
			&& 2*$_[1][$_[0]] <= $f[$_[0]][1]
		}, ((0) x @f);
	return sub {
		my $a;
		return unless $a = $l->();
		my $p = 1;
		$p *= $f[$_][0]**(2*$a->[$_]) for 0..$#f;
		return $p;
	}
}

sub is_prime {
	my $test = $_[0];
	my $lim = sqrt($test);
	for(@primes) {
		return 1 if $_ > $lim;
		return if $test % $_ == 0;
	}
	while(my $p = next_prime()) {
		return 1 if $p > $lim;
		return if $test % $p == 0;
	}
}

sub lcm($$) {
	return $_[0] * $_[1] / gcd($_[0], $_[1]);
}

# Seive functions
sub all_divisors {
	my ($n) = @_;
	my @divisors = ([], [], map { [1] } 2..$n);
	for my $div (1..int($n/2)) {
		for(my $mul=2; $mul*$div <= $n; $mul++) {
			push @{$divisors[$mul*$div]}, $div;
		}
	}
	return @divisors;
}

# Produces a list of the "first half" of all prime divisors - that is,
# everything but the number itself if it's prime.
sub half_divisors {
	my ($n) = @_;
	my $max = int(sqrt($n));
	my @divisors = (map { [] } 0..$n);
	for my $prime (2..$max) {
		next if @{$divisors[$prime]} > 0;
		my $maxpow = int(log($n)/log($prime));
		for my $pow (1..$maxpow) {
			my $prime_power = $prime ** $pow;
			for(my $val=$prime_power; $val <= $n; $val += $prime_power) {
				push @{$divisors[$val]}, $prime;
			}
		}
	}
	return @divisors;
}

# Compute a^b mod n for large b
sub binary_power_mod {
	my ($a, $b, $n) = @_;
	return 1 if $b == 0;
	return $a if $b == 1;
	my ($p, $r) = (int($b/2), $b%2);
	my $ap = binary_power_mod($a, $p, $n);
	return ((($ap * $ap) % $n) * $a ** $r) % $n;
}

1;
