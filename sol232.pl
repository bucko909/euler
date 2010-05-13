# Dynamic programming.
use strict;
#use warnings; # Deep recursion warnings abound.

my $target = 100;
# Evaluate 2 turns worth. $vals[i-1][j-1] holds the prob of winning, picking the
# best play, and playing first, if player 1 has to score j to win and player
# 2 has to score i.
my @vals = ( );
sub prob {
	my ($me, $them) = @_;
	return $vals[$me][$them] if defined $vals[$me][$them];
	my $win = 1;
	my $best = -1;
	while(1) {
		my $pwin = 0.5/$win;
		my $plose = 1-$pwin;
		# They lose, we win.
		my $this = ($me >= $win ? prob($me-$win, $them) : 1)*$pwin/2;
		# They win, we win.
		$this += ($me >= $win ? ($them ? prob($me-$win, $them-1) : 0) : 1)*$pwin/2;
		if ($them) {
			# They win, we lose.
			$this += prob($me, $them-1)*$plose/2;
		}
		# Both lose makes a recursion
		$this /= 1 - $plose/2;
		if ($this > $best) {
			$best = $this;
		}
		last if $win > $me;
		$win *= 2;
	}
	return $vals[$me][$them] = $best;
}

prob(10,$_) for 1..$target-1; # A bit of precaching to save recursion depth.

printf("%0.8f\n", (prob($target-1, $target-1)+prob($target-1,$target-2))/2);
