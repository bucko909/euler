# Simple brute force. Not really much else can be done.
use Lib;
open NAMES, "words.txt";
my @names = split ',', <NAMES>;
close NAMES;
s/.*"(.*)".*/$1/ for @names;
my $count = 0;
for(sort @names) {
	my $total = Lib::sum map { ord(uc$_) - ord('A') + 1 } split //;
	if (Lib::is_triangle($total)) {
		$count++;
	}
}
print "$count\n";
