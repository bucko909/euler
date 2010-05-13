#!/usr/bin/perl
#
# Notice that we may as well assume that 2 is included; the sum from 3 to inf
# of 1/n^2 is <0.5.
#
# There are two approaches here: We can evaluate partial sums to see if
# there's "enough sum left" to cover the remainder; if not we can give up.
#
# Secondly, and more interestingly, we can investigate prime factors. Suppose
# that the current remainder is a/b (in lowest terms, of course), and
# b=p^(2i)b' where p does not divide b'. Then if p does not divide c we have
# a/b+1/(p^nc)^2=(ac^2-b')/c^2b'p. So we can eliminate "all but one" p this
# way, and get rid of the last p by solving ac^2=b' mod p for c.
#
# If b=pb' and (b',p)=1 then we can only add copies of p:
# a/b+1/(cp)^2=(ac^2p-b')/(b'c^2p^2) -- and this is in lowest terms.
#
# The point of this is to try to eliminate large primes from the possibilities
# (notice that the solutions up to 45 never use primes above 7).
#
# We immediately observe that any prime must be less than 80/2 in order that
# it can be added and then eliminated again.

use Lib::NumberTheory;
use Lib::Lists;
use strict;
use warnings;

my $max = 80;
my @primes = Lib::flatten Lib::hclip { $_ <= $max } Lib::primes;

sub reduce {
	my ($a, $b) = @_;
	return (0,1) if $a==0;
	return (-1,1) if $a<0;
	my ($x, $y) = ($b, $a);
	($x, $y) = ($y, $x % $y) while $y;
	return ($a / $x, $b / $x);
}

sub subtract {
	my ($a, $b, $c) = @_;
	return reduce($a*$c*$c-$b,$b*$c*$c);
}

sub add {
	my ($a, $b, $c) = @_;
	return reduce($a*$c*$c+$b,$b*$c*$c);
}

sub count_configs {
	my($p,$a,$b,$c,$mask,@a) = @_;

	if($c*$p>$max) {
		my $q = $p % 2 ? $p**2 : $p;
		return $b % $p**2 != 0 ? [\@a] : [];
	}

	my $v = count_configs($p,$a,$b,$c+1,$mask,@a);
	if (ref $v && $c * @$v > 50) {
		return 1;
	} elsif (ref $v) {
		local $mask->[$c] = 1;
		my $u = count_configs($p,reduce($a*($c*$p)**2+$b,$b*($c*$p)**2),$c+1,$mask,@a,$c);
		return ref $u ? [@$u, @$v] : 1;
	} else {
		return 1;
	}
}

my @n_valid = (0, 0, (1) x ($max - 1));
my @p_p_valid;
my @p_power;
my @p_p_bits;
for my $p (@primes) {
	for (my $q=$p; $q <= $max; $q *= $p) { # Small primes can be a PITA
		next if $q == 2; # Can't do 1/2
		my $valid = count_configs($q, 0, 1, 1, []);
		if (ref $valid) {
			push @p_power, $q if @$valid > 1;
			$p_p_bits[$q] = $valid; # if @$valid > 1;
			my @results;
			my @muls;
			for my $set (@$valid) {
				$muls[$_] = 1 for @$set;
				$set = [ map { $_ * $q } @$set ];
			}
			$n_valid[$_*$q] &&= $muls[$_] for 1..$max/$q;
			for (1..$max/$q) {
				my $n = $_ * $q;
				next unless $n_valid[$n];
				$p_p_valid[$n] = 1;
			}
			last;
		}
	}
}

# Get a list of numbers we /can't/ eliminate using the above analysis.
my @bad_nums = grep { $n_valid[$_] && !$p_p_valid[$_] } 2..$max;
print "@bad_nums\n";

my @good_nums = grep { $n_valid[$_] && $p_p_valid[$_] } 2..$max;
print "@good_nums\n";

my $good_sum = 0;
$good_sum += 1/$_/$_ for @good_nums;

# We now have a list of all possible subsets which a) contain a given number
# and b) can cancel primes in that number. We'll pick sets from bad_nums, then
# try to fix the primes that we end up with.

recurse_bad_nums(1, 2, [], [], @bad_nums);

my %valid;
sub recurse_bad_nums {
	my ($a, $b, $d, $mask, $c, @remain) = @_;
	return if $a < 0;
	if ($c) {
		recurse_bad_nums($a, $b, $d, $mask, @remain);
		local $mask->[$c] = 1;
		recurse_bad_nums(subtract($a, $b, $c), [@$d, $c], $mask, @remain);
	} else {
		return if ($a/$b > $good_sum);
		$valid{"$a $b"} ||= [];
		push @{$valid{"$a $b"}}, $d;
		#print "fix_primes?($a, $b, @$d)\n";
		#fix_primes($a, $b, [@p_power], $mask, $d);
	}
}

my $count = 0;
fix_primes(0, 1, [@p_power], [], []);
print "$count\n";

sub fix_primes {
	my ($x, $y, $p, $mask, $l) = @_;
	#print "fix_primes($x, $y, @$p, @$l)\n";
	# We have no primes to work with, so we need to add at least one /good/
	# number to the list.
	if (@$p == 0) {
		my @l = sort { $a <=> $b } @$l;
		my $c = 0;
		$c += $mask->[$_] || !$n_valid[$_] ? 0 : 1 for 2..$max;
		$count += @{$valid{"$x $y"}} if $valid{"$x $y"};
		return;
	}
	my $p_power = shift @$p;
	choices: for my $choices (@{$p_p_bits[$p_power]}) {
		my @mask = @$mask;
		my ($x, $y) = ($x, $y);
		my @l = @$l;
		my $i = 0;
		my $choice = $choices->[$i] || $max + 1;
		for(1..$max/$p_power) {
			my $n = $_ * $p_power;
			if ($n != $choice) {
				if ($mask[$n] && $mask[$n] == 1) {
					next choices;
				}
				$mask[$n] = -1;
			} elsif ($n == $choices->[$i]) {
				$i++ if $i < $#$choices;
				$choice = $choices->[$i];
				if ($mask[$n] && $mask[$n] == -1) {
					next choices;
				}
				if (!$mask[$n]) {
					$mask[$n] = 1;
					($x, $y) = add($x, $y, $n);
					if ($x < 0) {
						next choices;
					}
					push @l, $n;
				}
			}
		}
		fix_primes($x, $y, $p, \@mask, \@l);
	}
	unshift @$p, $p_power;
}
