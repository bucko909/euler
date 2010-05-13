# Observing the technique for solving Pell's equation a^2-2b^2=1 we see that
# a^2-2b^2=(4a+3b)^2-2(3a+2b)^2.
# Now note that (a-1/2)^2 - 2(b-1/2)^2 + 1/4 = a(a-1) - 2b(b-1)
# Let a' = 2a-1, b' = 2b-1, so that we now need (a'/2)^2 - 2(b'/2) = 1/4
# This is satisfied easily by a'=b'=1.
# We now just need iterate to find all a, b.

my ($a_, $b_) = (1, 1);
my ($a, $b);
while($a<10**12) {
	($a_, $b_) = (3*$a_ + 4*$b_, 2*$a_ + 3*$b_);
	($a, $b) = (($a_ + 1)/2, ($b_ + 1)/2);
}
print "$b\n";
