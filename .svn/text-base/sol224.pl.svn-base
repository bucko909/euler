# Note that the generating matrices for Pyth triples apply here also.
# Eg. (a-2b+2c)^2+(2a-b+2c)^2-(2a-2b+3c)^2
# = a^2 + b^2 - c^2 + a(2c-2b-2b+4c-6c+4b) + ...
# = a^2 + b^2 - c^2
#
# TODO prove this works.
#
# It seems likely, then, that the matrices generate all triples when fed the
# smallest one. 0,0,1 is a pretty obvious starting point but is degenerate and
# all matrices change it to 2,2,3, so start there.
#
# This solution is very, very slow. Part of this is likely to be the large
# amount of recursion required. Implementing as a loop may help to aleviate
# this, but the recursion is not a single tail recursion, so it will mean
# manually emulating the large stack with an array.

my @trans = (
	sub {
		my ($a, $b, $c) = @_;
		return ($a-2*$b+2*$c, 2*$a-$b+2*$c, 2*$a-2*$b+3*$c);
	},
	sub {
		my ($a, $b, $c) = @_;
		return ($a+2*$b+2*$c, 2*$a+$b+2*$c, 2*$a+2*$b+3*$c);
	},
	sub {
		my ($a, $b, $c) = @_;
		return (-$a+2*$b+2*$c, -2*$a+$b+2*$c, -2*$a+2*$b+3*$c);
	},
);
my $limit = 75*10**6;
my $count = 0;
my %seen;
sub recurse {
	my ($a, $b, $c) = @_;
	return if $a + $b + $c > $limit;
	($a, $b) = ($b, $a) if $a > $b;
	my $s = "$a $b $c";
	return if $seen{$s};
	$count++;
	$seen{$s} = 1;
	recurse($_->(@_)) for @trans;
}
recurse(2,2,3);
print "$count\n";
