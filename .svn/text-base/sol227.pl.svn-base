# Due to the precision required, simulation is not enough.
# Start by filling an array with P(i) probability that the modulo difference in
# positions is i. For the 0th turn this is (1, 0, 0, 0, ...).
# Each die roll has a 1/6 prob of adding one, a 1/6 prob of subtracting and
# 4/6 of staying the same. We do two of these per turn.
# We are interested in P(0) at each turn.

# At first I read that the dice both started at 0. In this case:
# This isn't strictly true; there is a probability that we're on 0 but we
# got there by only moving one of the dice. The number of ways of doing this
# with k 6s and 1s, getting a 6 first is the kth Catalan number ncr(2k,k)/(k+1)
# times ncr(i,2k) for the ways of fitting this into all the stationary rolls.
# We need to count from k=1 to i/2. Also, since there are 2 possibly stationary
# dice, and we can get a 6 or a 1 first, we must multiply this by 4.
# The probability of doing this is 4^(2i-2k)*1^(2k)/6^(2i) = (4/9)^i/16^k.
# It's also possible that we got this by doing 100+k 6s and k 1s, but the
# chances of this are extremely remote (<10^-18).
# Finally, we could have moved nothing, with prob (4/9)^i.
# Let the sum of all of these probabilities be r. Then the probability of the
# game ending in i turns is P(0)-r.

# Because of the above issue I assumed that a Markov approach was not
# sufficient, and went with a simulation. Since it's not an issue, one can use
# Markov chain techniques to make a transition matrix which noms at 0, then
# solve using normal matrices etc. (If Q is matrix, answer is 50th row of
# (I-Q)^-1 times a column vector of all 1s.)

# The problem can be made simpler by noting that we're only concerned with
# distance from 0.

sub ncr {
	my ($n, $r) = @_;
	my $i = 1;
	$i *= ($r+$_)/$_ for(1..($n-$r));
	return $i;
}
my @p = ((0) x 50, 1, (0) x 49);
my $i = 0;
my $e = 0;
my $thresh = 10**-11;
while ( 1 ) {
	$i++;
	for(1,2) {
		my $s = $p[0];
		my $last = $p[$#p];
		($last, $p[$_]) = ($p[$_], ($last+4*$p[$_]+$p[$_+1])/6) for(0..$#p-1);
		$p[$#p] = ($s+4*$p[$#p]+$last)/6;
	}
	my $add = $i * $p[0];
	$e += $add;
	last if $i > 1000 && $add < $thresh;
	$p[0] = 0;
}
printf("%10f\n", $e);
