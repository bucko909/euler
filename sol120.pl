# What.
#   (a-1)^n + (a+1)^n mod a^2
# = a^2(...) + (-1)^(n-1)(n-1)a + (n+1)a + (-1)^n + 1 mod a^2
# = 2na mod a^2 (n odd)
#   2a + 2 mod a^2 (n even)

use Lib;

sub get_max {
	my ($a) = @_;
	my $max = int(($a-1)/2);
	return 2*$max*$a;
}

my $a = Lib::sum map { get_max $_ } (3..1000);
print "$a\n";
