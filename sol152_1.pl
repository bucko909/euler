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

# Let's find the values of n^2 modulo p for each prime power to save time
# later.
my @mods = ();
my @modexist;
for my $p (@primes) {
	for(my $q=$p;$q<=$max;$q*=$p) {
		$mods[$q] = [];
		$modexist[$q] = [];
		for my $n (1..$max/$q) {
			my $m = $n**2 % $q;
			next unless $m;
			if (!$mods[$q][$m]) {
				$mods[$q][$m] = [];
				push @{$modexist[$q]}, $m;
			}
			push @{$mods[$q][$m]}, $n;
		}
	}
}

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

sub count_configs {
	my($p,$a,$b,$c,$filter,$mask,@a) = @_;

	my @filter2;
	my $f;
	a: for my $test (@$filter) {
		$f = 1;
		for (@{$test->[0]}) {
			unless ($mask->[$_]) {
				$f = 0 if $_ < $c;
				next a;
			}
		}
		# Matches a complete filter
		return [];
	} continue {
		push @filter2, $test if $f;
	}
			
	if (@a > 0 && $b % ($p**2) != 0) {
		return [\@a];
	}
	if($c*$p>$max) {
		return [];
	}

	my @new_filter = grep { !$_->[$c] } @filter2;
	my $v = count_configs($p,$a,$b,$c+1,\@new_filter,$mask,@a);
	if (ref $v && $c * @$v > 200) {
		return 1;
	} elsif (ref $v) {
		my @new_filter_2 = ((map { my@a=($_);$a[$_]=1 for@$_;\@a } @$v), @filter2);
		local $mask->[$c] = 1;
		my $u = count_configs($p,reduce($a*($c*$p)**2+$b,$b*($c*$p)**2),$c+1,\@new_filter_2,$mask,@a,$c);
		return ref $u ? [@$u, @$v] : 1;
	} else {
		return 1;
	}
}

my @n_valid = (0, 0, (1) x ($max - 1));
my @p_p_valid;
for my $p (@primes) {
	for (my $q=$p; $q <= $max; $q *= $p) { # Small primes can be a PITA
		next if $q == 2; # Can't do 1/2
		my $valid = count_configs($q, 0, 1, 1, [], []);
		if (ref $valid) {
			my $s1 = 2**int($max/$q);
			my $s2 = @$valid;
			my $r = $s2/$s1;
			my @muls;
			my @results;
			for my $set (@$valid) {
				$muls[$_] = 1 for @$set;
				$set = [ map { $_ * $q } @$set ];
			}
			$n_valid[$_*$q] &&= $muls[$_] for 1..$max/$q;
			for (1..$max/$q) {
				my $n = $_ * $q;
				next unless $n_valid[$n];
				$p_p_valid[$n][0]{$q} = 1;
				my @filtered = grep { grep { $_ == $n } @$_ } @$valid;
				$p_p_valid[$n][$q] = \@filtered;
				print "$n/$q: ".join(", ", map { "@$_" } @filtered)."\n";
			}
			last;
		}
	}
}

# Get a list of numbers we /can't/ eliminate using the above analysis.
my @bad_nums = grep { $n_valid[$_] && !$p_p_valid[$_] } 2..$max;
print "Bad nums: @bad_nums\n";

my @good_nums = grep { $n_valid[$_] && $p_p_valid[$_] } 2..$max;
print "Good nums: @good_nums\n";

my $good_sum = 0;
$good_sum += 1/$_/$_ for @good_nums;
print "Good sum: $good_sum\n";

# Cache the partial sums, so we know a maximum bound on the smallest number
# to add to the candidate list.
my @sums;
$sums[$max+1] = 0;
for(reverse 2..$max) {
	my $val = $n_valid[$_] ? 1/$_/$_ : 0;
	$sums[$_] = $sums[$_+1] + $val;
}

# We now have a list of all possible subsets which a) contain a given number
# and b) can cancel primes in that number. We'll pick sets from bad_nums, then
# try to fix the primes that we end up with.

recurse_bad_nums(1, 2, [], [], @bad_nums);

sub recurse_bad_nums {
	my ($a, $b, $d, $mask, $c, @remain) = @_;
	if ($c) {
		recurse_bad_nums($a, $b, $d, $mask, @remain);
		local $mask->[$c] = 1;
		recurse_bad_nums(subtract($a, $b, $c), [@$d, $c], $mask, @remain);
	} else {
		return if ($a/$b > $good_sum);
		fix_primes($a, $b, $mask, $d);
	}
}

sub fix_primes {
	my ($a, $b, $mask, $l) = @_;
	print "fix_primes($a, $b, @$l)\n";
	# We have no primes to work with, so we need to add at least one /good/
	# number to the list.
	my $rolling_sum = 0;
	for my $i (0..$#good_nums) {
		my ($x, $y) = subtract($a,$b,$good_nums[$i]);
		last if ($x/$y > $good_sum - $rolling_sum);
		$rolling_sum += 1/$good_nums[$i]**2;
		local $mask->[$good_nums[$i]] = 1;
		fix_primes_2($x, $y, $good_nums[$i], $mask, [@$l, $good_nums[$i]]);
	}
}

sub fix_primes_2 {
	my ($a, $b, $added, $mask, $l) = @_;
	print "fix_primes_2($a, $b, $added, @$l)\n";
	my %p_powers = map { $_ => [] } keys %{$p_p_valid[$added][0]};
	do_stuff($a, $b, $added, \%p_powers, [keys %p_powers], 0, $mask, $l);
}

sub do_stuff {
	my ($a, $b, $min, $ignore, $primes, $index, $mask, $l) = @_;
	#printf("do_stuff(%10i, %10i, %2i, %-20s, %2i, %-s)\n", $a, $b, $min, "@$primes", $primes->[$index], "@$l");
	# Try to fix up prime $index (if it's bad).

	my $prime = $primes->[$index];
	my $is_bad = 0;
	for my $test (@$l) {
		next unless $p_p_valid[$test][$prime];
		if ($ignore->{$prime}[$test]) {
			next; # this one's OK.
		} else {
			list: for my $list (@{$p_p_valid[$test][$prime]}) {
				# Every element must be either >= $test or not in @l
				my @new;
				for (@$list) {
					next list if $ignore->{$prime}[$_] || !$n_valid[$_];
					push @new, $_ unless $mask->[$_];
				}
				my @added_p_powers;
				my ($x, $y) = ($a, $b);
				for (@new) {
					($x, $y) = subtract($x, $y, $_);
					next list if $x < 0;
				}
				$ignore->{$prime}[$test] = 1;
				for (@new) {
					$mask->[$_] = 1;
					$ignore->{$prime}[$_] = 1;
					push @$l, $_;
					for (keys %{$p_p_valid[$_][0]}) {
						next if $ignore->{$_};
						push @added_p_powers, $_;
						$ignore->{$_} = [];
						push @$primes, $_;
					}
				}
				do_stuff($x, $y, $min, $ignore, $primes, 0, $mask, $l);
				pop @$l for(@new);
				undef $ignore->{$prime}[$_] for(@new,$test);
				undef $mask->[$_] for(@new);
				pop @$primes for (@added_p_powers);
				delete $ignore->{$_} for (@added_p_powers);
			}
			return;
		}
	}
	if ($index == $#$primes) {
		# Are we done?
		my @l;
		{ our ($a, $b); @l = sort { $a <=> $b } @$l }
		print "$a/$b @l\n" if $a == 0;
	} else {
		do_stuff($a, $b, $min, $ignore, $primes, $index + 1, $mask, $l);
	}
}
