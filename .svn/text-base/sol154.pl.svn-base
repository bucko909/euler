# Value of cell that is i from the left, j from the bottom, and i+j+k=200000
# is 200000!/i!/j!/k!
#
# Look at the prime factors. Need 12 or more 2s and 12 or more 5s.
#
# #p in n! is sum floor(n/p^k)
#
# #2 in 200000! is 100000 + 50000 + 25000 + ... =~ 200000.
# #5 in 200000! is 40000 + 8000 + 1600 + ... =~ 50000.
#
# floor(n/k) = floor((n-(n%k))/k) = (n-n%k)/k.
#
# Want floor(200000/p^l) - sum x in (i,j,k) floor(i/p^l) for each l.
#
# So (200000-i-j-k)/p^l - (200000%p^l - i%p^l - j%p^l - k%p^l)/p^l
#  = (i%p^l + j%p^l + k%p^l - 200000%p^l)/p^l
#
# So we have #p in 200000!/i!j!k! is sum (i%p^l+j%p^l+k%p^l-200000%p^l)/p^l
# Numerator is 0 if p^l >= 200000.
#
# Keeping l constant (q=p^l, n=200000), see that we get between 0 and 2 for
# each summand. (Can't have <0 multiples; 3(q-1) < 3q)
#
#           i%q+j%q <= n%q      gives 0 (sum can't get to q)
#     n%q < i%q+j%q <= n%q + q  gives 1 (sum can't be 0, sum can't reach 2q)
# q + n%q < i%q+j%q             gives 2 (since sum >q)
#
# Thus the pyramid floor, if arranged into a half-square, is made of q*q blocks
# with 0 in top left for n%q+1 units, and 2 in bottom right for q-n%q-2 units.
#
# That is, for q=5^1, one of:
#
# n%5=0     1     2     3     4
#
# 01111 00111 00011 00001 00000
# 11111 01111 00111 00011 00001
# 11112 11111 01111 00111 00011
# 11122 11112 11111 01111 00111
# 11222 11122 11112 11111 01111
#
# Look at residues of 200000 modulo powers of 5:
# 5^6: 200000%15625 is 12500
# 5^7: 200000%78125 is 43750
# (rest are 0 or 200000 so almost 1/2 are 2s or all are 0s)
# 
# The powers of 2 are much more wild, so use those as a check instead of
# search.
#
# There needs to be a sum for each spot of 12 or more to be a possibility,
# that is, 6*2+0 or 5*2+1+1

my $n = 200000;
my @possibilities;

# 6*2+0
for my $notused_pow (1..7) {
	# These lie in the bottom right corner of the 5^7 block.
	my @current = ([0,0]);
	for my $pow (1..7) {
		my @new;
		if ($pow == $notused_pow) {
			# Replicate previous onto zeros.
			# Whatever is fully covered.
			my $full = int(($n%(5**$pow))/(5**($pow-1))) - 1;
			print "Computed a bigass triangle, side length $full at power $pow\n";
			for my $i (0..$full-1) {
				for my $j (0..$full-$i-1) {
					push @new, map { [ $i*5**($pow-1) + $_->[0], $j*5**($pow-1) + $_->[1] ] } @current;
				}
			}
		print "T$pow ".join(', ', map { "[@$_]" } @new)."\n";

			# This is how far we're allowed to go into terminal triangles.
			# pp...    ppppp  (that is, partial_width across or partial_width+1 down)
			# p....    ppppp
			# ..... or ppppp
			# .....    pppp.
			# .....    ppp..
			my $partial_width = ($n+1) % (5**($pow-1));
			for my $v (0..$full) {
				my $i = $full - $v;
				my $j = $v;
				push @new, map { [ $i*5**($pow-1) + $_->[0], $j*5**($pow-1) + $_->[1] ] }
					grep { $_->[0] + $_->[1] < $partial_width + 5 } @current;
			}
		print "T$pow ".join(', ', map { "[@$_]" } @new)."\n";
			for my $v (0..$full+1) {
				my $i = $full - $v + 1;
				my $j = $v;
				push @new, map { [ $i*5**($pow-1) + $_->[0], $j*5**($pow-1) + $_->[1] ] }
					grep { $_->[0] + $_->[1] <= $partial_width } @current;
			}
		print "T$pow ".join(', ', map { "[@$_]" } @new)."\n";
		} else {
			# Replicate onto twos.
			@new = @current;
		}
		@current = @new;
		print "$pow ".join(', ', map { "[@$_]" } @current)."\n";
	}
}

print "cock\n";


my $n = 100;
for $n (0..200) {
my $d1 = 2;
my $d2 = 5;
my $c1 = 12;
my $c2 = 12;
my @a;
for my $i (0..$n) {
	for my $j (0..$n-$i) {
		$q = 25;
		my $c = count($n, $q) - count($i, $q) - count($j, $q) - count($n-$i-$j, $q);
		$a[$i][$j] = $c ? $c : 0;
	}
}

for(@a) {
	print join('', @{$_})."\n";
}
<>;
}

sub count {
	my ($t, $p) = @_;
	my $c = 0;
	my $m = 1;
	$c += int($t/($m*=$p)) while $m <= 1;
	return $c;
}
