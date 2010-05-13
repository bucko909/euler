# Just compute them. There's not so many...
use Lib::Lists;
use Lib::Utils;
my $sum = Lib::sum
	Lib::flatten
	Lib::hgrep { $_ % 2 == 0 } # Only even numbers
	Lib::hclip { $_ <= 4000000 } # Stop when we get too big
	Lib::fibonaccis;
print "$sum\n";
