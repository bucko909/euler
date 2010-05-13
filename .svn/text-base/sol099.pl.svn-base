# Easiest ever. Just compute log(a^b) = b log a. It's an increasing function,
# so you can just compare those.
my @vals;
open BASEEXP, "base_exp.txt";
while($_ = <BASEEXP>) {
	/(\d+),(\d+)/;
	push @vals, $2*log($1);
}
my @sorted = sort { $vals[$b] <=> $vals[$a] } (0..$#vals);
print "$vals[$sorted[0]] $vals[$sorted[1]]\n";
print "@sorted\n";
my $res = $sorted[0] + 1;
print "$res\n";
