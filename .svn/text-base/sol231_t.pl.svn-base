# Use a customised seive. We care only about numbers from 
my $n = 2*10**7;
my $r = 15*10**6;
my $sum = 0;
my $max = int(($n+1)/2);
my @seive = ((1) x $max);
my $max_prime = int((sqrt($n)+1)/2);
$sum += sum_factors($n, $r, 2);
use Time::HiRes qw/gettimeofday tv_interval/;
my $s = [gettimeofday];
for my $primen (2..$max_prime) {
	next unless $seive[$primen];
	# First do the seive
	if ($prime <= $max_prime) {
		my $start = 3*$primen-1;
		my $add = 2*$primen-1;
		for(my $num=$start; $num <= $max; $num += $add) {
			$seive[$num] = 0;
		}
		print "seived $primen ".tv_interval($s)."\n";
	}
	$sum += sum_factors($n, $r, 2*$primen-1);
}
for my $primen ($max_prime+1..$max) {
	next unless $seive[$primen];
	$sum += sum_factors($n, $r, 2*$primen-1);
}

sub sum_factors {
	my ($n, $r, $prime) = @_;
	my $sum = 0;
	my $max_pow = int(log($n)/log($prime));
	for my $pow (1..$max_pow) {
		my $prime_power = $prime**$pow;

		# Find the number that live between 1 and $r.
		my $num_not_present = int($r / $prime_power);
		$sum -= $prime * $num_not_present;

		# Find the number that live between $n-$r+1 and $n.
		my $offset = ($n-$r+1) % $prime_power;
		my $num_present;
		if ($offset == 0) {
			$num_present = int(($r-1) / $prime_power) + 1;
		} else {
			$num_present = int(($r-1+$offset) / $prime_power);
		}
		$sum += $prime * $num_present;
	}
	return $sum;
}

print "$sum\n";
