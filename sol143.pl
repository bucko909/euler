# Using the cosine rule, if the triangle has sides of lengths a, b, c then
#
# a^2=q^2+r^2-2qr cos(120) = q^2+r^2+qr
# (120 degree from simple circle chord theory, since equilateral triangles have
# angle 60 degrees)
# So each such combination is a perfect square.
# We have r^2+qr+q^2-a^2=0
# So (r+q/2)^2+3q^2/4-a^2=0
# So (2a)^2-(2r+q)^2=3q^2
# So (2a-2r-q)(2a+2r+q)=3q^2
# Thus we must find all the divisors of 3q^2.
# So we must factor every number up to 110000.
# If 3q^2=uv then 4y=u+v so a=(u+v)/4.
# Also 4r+2q=v-u so r=(v-u-2q)/4. Since r+q<110000, 2q+v-u<440000.
# We can assume u, v are positive so v-3q^2/v+2q-440000<0.
# So v^2+(2q-440000)v-3q^2<=0
# Solve for v: v<=220000-q+sqrt((220000-q)^2+3q^2)
#
# This is /very/ slow (25 secs on my machine). It turns out to be faster
# to solve the top equation in terms of three variables by solving x^2+xy+y^2=1
# for rationals, which can be done using the fact that (1,0) is a solution, then
# substituting y=m(x-1) and finding the roots of the quadratic. Need to read up
# on forum as this seems useful.

use strict;
use warnings;

my $target = 110000;
my @pfacts = (undef, map { [] } 1..$target);
for my $cand (2..$target) {
	next if @{$pfacts[$cand]};
	my $p = $cand;
	for(my $n = $p; $n < $target; $n+=$p) {
		push @{$pfacts[$n]}, [$cand, 1];
	}
	$p *= $cand;
	while($p < $target) {
		for(my $n = $p; $n < $target; $n+=$p) {
			$pfacts[$n][$#{$pfacts[$n]}][1]++;
		}
		$p *= $cand;
	}
}

my %r; # Hash to store unique values

for(my $q=1; $q < $target / 3; $q++) {
	my @possibilities = sort { $a <=> $b } grep { $_ >= $q && $_ == int $_ } map {
		(-2*$q+$_-3*$q*$q/$_)/4
	} map { ($_, -$_) } factors($q, 2*$target-$q+sqrt((2*$target-$q)**2+3*$q*$q));
	for my $r (@possibilities) {
		last if $q+$r > $target;
		my @newpos = grep { $_ >= $r } @possibilities;
		for my $p (@possibilities) {
			last if $p+$q+$r > $target;
			my $root = sqrt($r*$p+$r*$r+$p*$p);
			next unless $root == int $root;
			my $a = sqrt($q*$q+$r*$q+$r*$r);
			my $b = sqrt($p*$p+$p*$q+$q*$q);
			my $c = sqrt($p*$p+$p*$r+$r*$r);
			$r{$p+$q+$r} = 1;
		}
	}
}

my @res = keys %r;

my $sum = 0;
$sum += $_ for @res;
print "$sum\n";

sub factors {
	my @pfacts = reverse map { [ $_->[0], 2*$_->[1] ] } @{$pfacts[$_[0]]};
	return (3) unless @pfacts;
	if ($pfacts[0][0] == 3) {
		$pfacts[0][1]++;
	} elsif (@pfacts > 1 && $pfacts[1][0] == 3) {
		$pfacts[1][1]++;
	} else {
		push @pfacts, [3, 1];
	}
	my @factors = ();
	_factors(\@factors, 1, $_[1], @pfacts);
	sort { $a <=> $b } @factors;
}

sub _factors {
	my ($arr, $val, $max, $fact, @rest) = @_;
	if (@rest) {
		my $p = 1;
		for(0..$fact->[1]) {
			#last if $val*$p > $max;
			_factors($arr, $val*$p, $max, @rest);
			$p *= $fact->[0];
		}
	} else {
		my $p = 1;
		for(0..$fact->[1]) {
			push @$arr, $p*$val;
			$p *= $fact->[0];
		}
	}
}
