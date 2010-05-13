# We can work out a neat solution to this one.
# First, note the following facts, where N(R, i, j) is the number of ways of
# picking a, b >= j such that a+b%2=i and a+b R 10:
# N(< ,0,0) = 25
# N(>=,0,0) = 25
# N(< ,1,0) = 30
# N(>=,1,0) = 20
# N(< ,1,1) = 20
# N(>=,1,1) = 20
#
# Now, if a[i] + a[n-i+1] >= 10 note that a[i+1] + a[n-i] must be even,
# otherwise it must be odd. To make them even, we must have
# a[a+2] + a[n-i-1] >= 10, so the property of >= 10 propogates along to
# alternate pairs, and is equivalent to the parity of the neighbouring ones.
#
# Thus, there are 2 choices to make:
#    Is a[1] + a[n]   >= 10?
#    is a[2] + a[n-1] >= 10?
# 
# Once these are made, we can simply do a multiple of the above N functions.
#
# Note that if n is odd, the digital sum of the middle is even plus the
# remainder of the neighbours modulo 10. Thus, a[(n-1)/2] + a[(n+3)/2] >= 10.
# But this contradicts a[1] + a[n] odd when n % 4 == 1, so there are no
# solutions there. Otherwise the parity and remainder alternate between (0, 0)
# and (1, 1). There's 5 ways of choosing the middle digit.
#
# Thus, we get 20 * 5 * (20*25) ^ ((n-3)/2)
# 
# If n is even, and the two middle digits sum to >= 10, then their neighbours
# must, too. But then, their neighbours must, and so on. Thus both choices must
# have the same outcome. Also, using a[1] + a[n] is odd, we can see that the
# we must have only odd numbers, and they must always sum to <= 10.
#
# Thus, we get 20 * 30^(n/2-1)

my $sum = 0;
for(1..8) {
	if ($_ % 4 == 1) {
		next;
	} elsif ($_ % 2 == 0) {
		my $k = $_ / 2 - 1;
		$sum += 20 * 30 ** ($_ / 2 - 1);
	} else {
		$sum += 20 * 5 * 500**(($_-3)/4);
	}
}
print "$sum\n";
