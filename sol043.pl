# Recursively chew through the list of digits, checking the division property
# as we go.
use strict;
use warnings;
my @divisors = (1,2,3,5,7,11,13,17);
my $count = 0;
sub nom {
	my ($sofar, @rest) = @_;
	my $len = length $sofar;
	if ($len > 3) {
		if(substr($sofar, $len-3, 3) % $divisors[$len-3]){
			return;
		}
	}
	if(@rest){
		for my $index (0..$#rest){
			nom($sofar.$rest[$index], @rest[0..$index-1,$index+1..$#rest]);
		}
	} else {
		$count += $sofar;
	}
}
nom("",0..9);
print "$count\n";
