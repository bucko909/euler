# This one isn't too hard. Recursively compute the permutations on a set of
# size n - 1, and use that to work out how many times we must permute the
# remainder, so we know which element we must pick.

# That is, the first element of the (i+1)th perm on a set a of n elts is
# a[i/(n-1)!]

use Lib;
sub permno {
	my ($n, @bits) = @_;
	my $l = scalar @bits;
	return '' unless @bits;
	my $fac = Lib::fac($l-1);
	my $pick = int($n / $fac);
	return $bits[$pick].permno($n-$pick*$fac, @bits[0..$pick-1,$pick+1..$#bits]);
}

print permno(1000000-1, 0..9)."\n";
