# This is easily brute forced. The code generates all numerators, then works out
# a set of possible denominators for each. It then tests each in turn.
use Lib;
use strict;
use warnings;
my ($prodden, $prodnum) = (1, 1);
for(my $num = 11; $num <= 98; $num++) {
	my %digits = map { ($_ => 1) } grep { $_ > 0 } split //, $num;
	my @unique_digits = keys(%digits);
	# Strictly speaking, the code is fast enough that we may as well loop all
	# up to 99 or so and test if there's a cancellable digit.
	my @loop = map { my $dig = $_;
		my ($start1, $end1);
		if ($num >= $dig*10+9) {
			($start1, $end1) = (0, -1);
		} elsif ($num >= $dig*10) {
			($start1, $end1) = ($num%10+$dig*10+1,$dig*10+9);
		} else {
			($start1, $end1) = ($dig*10, $dig*10+9);
		}
		my $end2 = 9;
		my $start2 = int(($num-$dig+10)/10);
		$start1..$end1, # digit appears first
		map { $_*10+$dig } $start2..$end2 # digit appears second
	} @unique_digits;
	for my $den (@loop) {
		for my $dig (@unique_digits) {
			next unless int($den/10) == $dig || $den % 10 == $dig;
			my ($den2, $num2) = ($den, $num);
			$den2 =~ s/$dig//;
			$num2 =~ s/$dig//;
			if ($num*$den2==$num2*$den) {
				$prodnum *= $num2;
				$prodden *= $den2;
			}
		}
	}
}
my $hcf = Lib::hcf($prodnum,$prodden);
$prodden /= $hcf;
print "$prodden\n";
