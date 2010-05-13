# To avoid bigints, use b log a. We need to do some rounding due to float
# errors.
my %terms;
for my $b (2..100) {
	$terms{sprintf("%0.8f",$b*log$_)} = 1 for(2..100);
}
my $count = keys %terms;
print "$count\n";
