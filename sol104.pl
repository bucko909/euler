# Computing the full fibonacci number as a bigint is slow, so we just compute
# the tail using modulo arithmetic. We can recursively compute the full number
# for each andidate.
use Lib;

# Speeds up calculations a lot. But not by enough; seems Math::BigInt is a bit
# daft when adding, say, 10**(10**10) and 10**(10**10) with accuracy 20.
Math::BigInt->accuracy(20);

my @fib = (map { Math::BigInt->new($_) } (0, 1, 1));
sub fib {
	my $n = $_[0];
	if (defined $fib[$n]) {
		return $fib[$n];
	} elsif ($n % 2 == 0) {
		my $n2plus1 = fib($n/2 + 1);
		my $n2minus1 = fib($n/2 - 1);
		my $v = $n2plus1**2 - $n2minus1**2;
		$fib[$n] = $v;
		return $v;
	} else {
		my $n2plus1 = fib(($n+1)/2);
		my $n2 = fib(($n-1)/2);
		my $v = $n2**2 + $n2plus1**2;
		$fib[$n] = $v;
		return $v;
	}
}

my $i1 = 1;
my $i2 = 1;
my $n = 2;
outer: while(1) {
	$i1 += $i2;
	$n++;
	($i1, $i2) = ($i2, $i1);
	$val = $i2 = $i2 % 10**9;
	next if $n < 541;
	my @digs = ((0) x 10);
	for(1..9) {
		$_ = $val % 10;
		$val = int($val / 10);
		next outer if $_ == 0 || $digs[$_] == 1;
		$digs[$_] = 1;
	}

	my $val = fib($n);
	for(map { $val->digit(-$_) } (1..9)) {
		if ($_ == 0 || $digs[$_] == 0) {
			next outer;
		}
		$digs[$_] = 0;
	}
	print "$n\n";
	exit
}
