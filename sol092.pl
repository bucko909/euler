# Rather than brute forcing, we just run over possible combinations of numbers.
# We do this by iterating length 7 increasing lists of numbers less than 9.
use Lib;
my @cache;
$cache[1] = 0;
$cache[89] = 1;
my @cached;
$cached[1] = $cached[89] = 1;
my @list = (0, 0, 0, 0, 0, 0, 0);
my @fac;
$fac[0] = 1;
$fac[$_] = $_ * $fac[$_-1] for 1..9;
my $count = 0;
while(1) {
	Lib::listinc_shortlex_increasing {
		return if @{$_[0]} > 7;
		return if $_[0][$#{$_[0]}] > 9;
		return 1;
	} \@list;
	next if @list < 7;
	last if @list > 7;
	my @bits = @list;
	my $result = 0;
	my @tocache;
	while(1) {
		my $sum = 0;
		$sum += $_**2 for @bits;
		if ($cached[$sum]) {
			$result = $cache[$sum];
			last;
		}
		push @tocache, $sum;
		@bits = split //, $sum;
	}
	my ($last, $found) = (-1, 0);
	my $bottom = 1;
	for(@list) {
		if ($_ == $last) {
			$found++;
		} else {
			$last = $_;
			$bottom *= $fac[$found];
			$found = 1;
		}
	}
	$bottom *= $fac[$found];
	my $add = $fac[scalar @list] / $bottom;
	$count += $add if $result;
	for(@tocache) {
		$cached[$_] = 1;
		$cache[$_] = $result;
	}
}
print "$count\n";
