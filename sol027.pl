# Brute force, ish. Look at a few values for n^2 + an + b: n=0 gives b. n=1
# gives 1 + b + a. Both of these should be prime. Precache primes up to a
# million to be sure we've got them all.
use Lib;
my @primes = Lib::flatten Lib::hclip { $_ <= 1000000 } Lib::primes;
my @pcheck;
$pcheck[$_] = 1 for @primes;
for my $b (@primes) {
	last if $b > 1000;
	for my $adash (@primes) {
		my $a = $adash - $b - 1;
		last if $a > 1000;
		my $n;
		for($n = 0; $pcheck[$n**2+$a*$n+$b]; $n++) {
		}
		if ($n > $max) {
			$max = $n;
			$maxv = $b * $a;
		}
	}
}
print "$maxv\n";
