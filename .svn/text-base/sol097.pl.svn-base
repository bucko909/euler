# This one's just easy modular arithmetic. It's possible to do it without BigInt
# but is more complex.
# Get some powers of 2.
use Lib;
my @p2 = (1);

# And some 2^(2^n)
my @p22 = (Math::BigInt->new(2));
my $mod = Math::BigInt->new(10000000000);
$_ = 0;
while(++$_) {
	$p2[$_] = 2 * $p2[$_-1];
	print "$p2[$_]\n";
	last if $p2[$_] > 7830457;
	my $val = $p22[$_-1]->copy();
	$val->bmul($p22[$_-1]);
	$val->bmod($mod);
	$p22[$_] = $val;
}

# Now just decompose the power in binary and bung the answers on the end.
my $i = 7830457;
my $prod = Math::BigInt->new(1);
for(0..$#p22) {
	my $p = $#p22 - $_;
	if ($i >= $p2[$p]) {
		print "foo $i $p2[$p]\n";
		$i -= $p2[$p];
		$prod->bmul($p22[$p]);
		$prod->bmod($mod);
	}
}
$prod->bmul(Math::BigInt->new(28433));
$prod->badd(Math::BigInt->new(1));
$prod->bmod($mod);
print "$prod\n";
