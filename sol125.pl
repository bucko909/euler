# Sum of squares is n(n+1)(2n+1)/6. This problem really was simple. No more
# explanation needed.
use Lib::Utils;
my $target = 10**8;
my $sum = 0;
my %met;
outer: for (my $start = 1; $start*$start < $target; $start++) {
	my $initial_sum = ($start-1)*$start*(2*$start-1)/6;
	for(my $end = $start+1; ; $end++) {
		my $sum_s = $end*($end+1)*(2*$end+1)/6 - $initial_sum;
		last if $sum_s > $target;
		if (Lib::is_palindrome($sum_s)) {
			next if $met{$sum_s};
			$met{$sum_s} = 1;
			$sum += $sum_s;
		}
	}
}
print "$sum\n";
