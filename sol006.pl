# The sum of the squares is (2n+1)(n+1)n/6.
# The square of the sums is (n(n+1)/2)**2.

my $n = 100;
my $sum_squares = (2*$n+1)*($n+1)*$n/6;
my $square_sum = $n * $n * ($n + 1) * ($n + 1) / 4;
my $diff = $square_sum - $sum_squares;
print "$diff\n";
