# Build up a cache for everything we've seen so far. An array of size 1000000
# isn't so big. We set values in the current chain to -1 so that we know when
# we've closed a loop.
#
# Once the loop closes, we set all elements to the chain length, except for
# those above (in the chain) the first repeating value. For these, we know they
# were in the loop, so they all get the same chain length of the first (and so,
# last) that we saw.
my @length = ();

# Also cache factorials. We only need 10 of 'em.
my @fac = (1);
for(1..9) {
	$fac[$_] = $fac[$_-1]*$_;
}

my $tot = 0;
for(1..1000000) {
	my $test = $_;
	my $current = $_;
	my @queue = ();
	while($length[$current] == 0) {
		push @queue, $current;
		$length[$current] = -1;
		my $new = 0;
		$new += $fac[$_] for split //, $current;
		$current = $new;
	}
	$length[$current] = 0 if $length[$current] < 0;
	my $found = 0;
	for(0..$#queue) {
		my $length = $found ? $found : @queue - $_ + $length[$current];
		$length[$queue[$_]] = $length;
		$found = $length if $queue[$_] == $current;
	}
	my $l = $length[$test];
	if ($l == 60) {
		$tot++;
	}
}
print "$tot\n"; 
