# The rect ones are easy. That's just w(w+1)h(h+1)/4.
# The diagonal ones correspond to # ways of fitting shapes which are
# thickened diagonal lines, for example, 1x2 is an L shape and 1x2 is an S
# tetris block.
# 1x1 1x2 1x3 1x4
# ##  ##   ##  ##
#     #   ##  ##
#             #
#
# 2x2        2x3 2x4
# ##  or  #   ##  ## or   #
# ##     ### ### ###     ###
#         #   #  ##     ###
#                        #
#
# 3x3  3x4   3x5
#  ##   ##     ##
# #### ####   ####
#  ##  ###   ####
#       #     ##
#
# Unioning all cases, we find:
# There are n of n*n+1 blocks, n of n+1*n and max(0,6n-7) of n*n blocks.
# Doing the sums, there are:

sub count {
	my ($s, $l) = @_;
	($s, $l) = ($l, $s) if $s > $l;
	my $t = int(($s-1)/2);
	return 8*$s*$s*($s+1)*($s+1)/4
		- (21+8*$s+8*$l)*$s*($s+1)*(2*$s+1)/6
		+ (8*$s*$l+14*($s+$l)+20)*$s*($s+1)/2
		- 7*$s*($s*$l+$s+$l+1)
		+ $s*($s+1)*$l*($l+1)/4
		+ $l*$s
}

# in total. There is of course a closed form for the problem, but I'd had enough
# of polynomial sums by this point; it's only 43*47 evaluations so it's not so
# bad.

my $sum = 0;
for my $w (1..43) {
	for my $l (1..47) {
		$sum += count($w, $l);
		print "$w x $l -> ".count($w, $l)."\n";
	}
}
print "$sum\n";
