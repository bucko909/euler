#!/usr/bin/perl

use strict;
use warnings;

# Represent the beastie on a square grid by skewing the y axis left.
# Then just explore all lexicographic triplets in which the second is on
# a line from the first and the third is on a line from the second.

# A more intelligent implementation might be a bit more careful about
# directions: If we know we're come out of a at angle theta1 and b at
# theta2 there's a smaller set of distances from a which b can lie and
# still make a triangle.

# This code works in 129s on my laptop.

# This holds the directions of lines. We assume squares are 6x6.
# All vectors point in direction of increasing lex order.
my @vectors = (
	[ 0, 1 ], # 2pi/6
	[ 1, 1 ], # pi/6
	[ 1, 0 ], # 0
	[ 2, -1 ], # -pi/6
	[ 1, -1 ], # -2pi/6
	[ 1, -2 ], # -3pi/6
);

# Offsets into a square, followed by the set of multiples allowed for each
# direction.
my @offsets = (
	[ 0, 0 ],
	[ 3, 0 ],
	[ 2, 2 ],
	[ 3, 3 ],
	[ 4, 4 ],
	[ 0, 3 ],
);

my @allowed;
$allowed[$_->[0]][$_->[1]] = $_ for @offsets;

# Mark vector multiples for each direction.
for my $off (@offsets) {
	my ($x, $y) = @$off;
	my $h = 0;
	for my $v (@vectors) {
		my $hit; # Test if the direction can possibly get us back to a corner.
		my @a = map { my ($a, $b) = (($x+$_*$v->[0])%6,($y+$_*$v->[1])%6); $hit = 1 if $a == 0 && $b == 0;
			$allowed[$a][$b] ? ([$v->[0]*$_, $v->[1]*$_]) : () } 1..6;
		$off->[2][$h] = \@a if $hit;
		$h++;
	}
}			

sub enumerate_subsequent(&@) {
	my ($sub, $max, $x, $y, $ignoredir) = @_;
	my $off = $allowed[$x%6][$y%6];
	return unless $off;
	for my $diri (0..$#{$off->[2]}) {
		my ($x, $y) = ($x, $y);
		next if $diri == $ignoredir;
		my $dir = $off->[2][$diri];
		next unless $dir;
		my $big = $dir->[$#$dir];
		point: while(1) {
			for my $add (0..$#$dir) {
				last point if $x + $dir->[$add][0] + $y + $dir->[$add][1] > $max || $y + $dir->[$add][1] < 0;
				$sub->($x + $dir->[$add][0], $y + $dir->[$add][1], $diri);
			}
			($x, $y) = ($x + $big->[0], $y + $big->[1]);
		}
	}
}

sub calc {
	my ($max) = @_;

	my $max6 = 6 * $max;

	my $count = 0;
	for my $x_ (0..$max) {
		for my $y_ (0..$max - $x_) {
			for my $off (@offsets) {
				my ($x, $y) = (6 * $x_ + $off->[0], 6 * $y_ + $off->[1]);
				next if $x + $y > $max6;
				enumerate_subsequent {
					my ($x2, $y2, $dire) = @_;
					enumerate_subsequent {
						my ($x3, $y3) = @_;
						if (test($x, $y, $x3, $y3)) {
							$count++;
						}
					} ($max6, $x2, $y2, $dire);
				} ($max6, $x, $y, -1);
			}
		}
	}

	return $count;
}


sub test {
	my ($x1, $y1, $x2, $y2) = @_;
	my $xd = $x1 - $x2;
	my $yd = $y1 - $y2;
	return 1 if $xd == 0 && $x1 % 6 == 0;
	return 1 if $yd == 0 && $y1 % 6 == 0;
	return 1 if $xd == $yd && ($x1 - $y1) % 6 == 0;
	return 1 if $xd == -$yd && ($x1 + $y1) % 6 == 0;
	return 1 if $xd == -2*$yd && ($x1 + 2*$y1) % 6 == 0;
	return 1 if -2*$xd == $yd && (2*$x1 + $y1) % 6 == 0;
	return;
}

print "".calc(36)."\n";
