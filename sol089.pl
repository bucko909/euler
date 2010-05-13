# Just wrote a roman<->machine format convertor.
use Lib;
open ROMAN, "roman.txt";
my $savings = 0;
while(my $num = <ROMAN>) {
	$num =~ s/\s//g;
	my $dec = Lib::read_legit_roman($num);
	my $min = Lib::minimal_roman($dec);
	my $saved = length($num) - length($min);
	$savings += $saved;
	print "N:$num D:$dec M:$min S:$saved\n";
}
print "$savings\n";
