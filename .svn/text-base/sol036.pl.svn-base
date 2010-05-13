# Generate the leading end of palindromes, then test if the binary expansion
# is palindromic.
use Lib;
my $sum = 0;
for my $lead (1..999) {
	next if $lead =~ /^[2468]/; # Can't be an even number.
	dup: for my $dup (0, 1) {
		my $n;
		if ($dup == 1) {
			$n = $lead.join('', reverse split //, $lead);
		} else {
			$n = $lead.join('', reverse split //, substr($lead,0,-1));
		}
		# $n is a palindrome.
		my @bits = ();
		my $n2 = $n;
		# Work out how deep we need to go to check palindrome-ness.
		my $length = log($n)/log(2);
		$length = $length == int $length ? $length + 1: int($length) + 1;
		my $length2 = int($length/2);
		my $odd = $length % 2;
		for(1..$length2) {
			push @bits, $n % 2;
			$n = int($n/2);
		}
		push @bits, $n % 2 if $odd;
		$n = int($n/2) if $odd;
		while($n > 0) {
			next dup if $bits[--$length2] != $n % 2;
			$n = int($n/2);
		}
		$sum += $n2;
	}
}
print "$sum\n";
