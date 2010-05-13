# Simple brute force. Not really much else can be done.
use Lib;
open NAMES, "names.txt";
my @names = split ',', <NAMES>;
close NAMES;
s/.*"(.*)".*/$1/ for @names;
my $line = 0;
my $total = 0;
for(sort @names) {
	$total += ++$line * Lib::sum map { ord(uc$_) - ord('A') + 1 } split //;
}
print "$total\n";
