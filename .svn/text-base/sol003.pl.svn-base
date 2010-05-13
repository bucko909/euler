# Just prime factorise the bugger. We divide as we go just it faster.
use Lib::Lists;
use Lib::NumberTheory;
my $target = 600851475143;
my $ans = Lib::hlast
	Lib::hgrep {
		# It's OK to use: $ret = $target % 0 == 0
		# However, this way we will check many less primes.
		my $ret = 0;
		while ($target % $_ == 0) {
			$target /= $_;
			$ret = 1;
		}
		$ret
	}
	Lib::hclip { $_*$_ <= $target } # Once the prime is too big we can stop.
	Lib::primes;
print "$ans\n";
