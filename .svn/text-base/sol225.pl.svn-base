# First, all of the terms are odd as the sequence begins three odd numbers and
# advances by adding the three previous (odd) terms.

# Consider the residue mod i. The sequence must repeat and must repeat after
# at most i^3 steps. We can reverse the sequence:
# i(n-3) = i(n) - i(n-1) - i(n-2) mod i. Thus, any repeat can be reversed back
# to 1, 1, 1 and there is no "initial segment".

# We can use a seive-like technique to speed things up: If a number does not
# divide any member of the sequence, nor does any multiple of it.

my @previous;
my $i = 5;
my $count = 0;
my $limit = 124;
while($i += 2) {
	my $not;
	if (grep { $i % $_ == 0 } @previous) {
		$not = 1;
	} else {
		my ($t1, $t2, $t3) = (1, 1, 3);
		my $c = $i*$i + $i + 1;
		while($t1 != 1 || $t2 != 1 || $t3 != 1) {
			$c = int($c/$i);
			($t1, $t2, $t3) = ($t2, $t3, ($t1 + $t2 + $t3) % $i);
			$c += $i * $i * $t3;
			last if $t3 == 0;
		}
		$not = $t3 != 0;
	}
	if ($not) {
		$count++;
		last if $count == $limit;
	}
}
print "$i\n";
