# Have (c-b)(c+b)=(a-1)(a+1)
#
# So factor (a+1)(a-1) = uv and c=(u+v)/2, b=(u-v)/2
# b>0 so v<u.
# b>=a so v>=u-2a.
# a+b+c<=target so v>=(a+1)(a-1)/(target-a)
# 
# If p|a+1 and p|a-1 then p|2 so p=2. Thus factors are is "almost"
# multiplicative and are multiplicative for even numbers.
#
# Let's do the seive.

# Need factors up to the sqrt(target+1), so primes up to there.
use Lib::NumberTheory;
use Lib::Lists;
my $target = 25*10**6;
my $maxa = int($target/3);
my $maxprime = int(sqrt($target+1));
my @primes = Lib::flatten Lib::hclip { $_ < $maxprime } Lib::primes;
my @pfactors = map { [] } (0..$maxa+1);
for my $prime (@primes[1..$#primes]) {
	for(my $num=$prime; $num<=$maxa+1; $num += $prime) {
		push @{$pfactors[$num]}, $prime;
	}
}
my $count = int(($target-1)/2); # a=1 not covered properly below.
for my $a (2..$maxa) {
	print "$a\n";
	# Simultaneously factor a+1 and a-1.
	my @factors = (1);
	my $mul = ($a+1)*($a-1);
	if ($a % 2 == 1) {
		add_factor(\@factors, 2, $mul, $a);
	}
	for(@{$pfactors[$a+1]}, @{$pfactors[$a-1]}) {
		add_factor(\@factors, $_, $mul, $a);
	}
	for(@factors) {
		$count++ if $_ >= $mul/$_ - 2*$a && $_ >= $mul/($target-$a);
	}
}
print "$count\n";
sub add_factor {
	my ($factors, $prime, $mul, $a) = @_;
	my @old = @$factors;
	my $max = int(sqrt($mul));
	while($mul % $prime == 0 && @old) {
		$mul /= $prime;
		@old = grep { $_ <= $max }
			map { $_ * $prime } @old;
		push @$factors, @old;
	}
}
