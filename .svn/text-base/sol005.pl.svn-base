# Just calculate the lcm of all of the numbers.
# lcm{a1, ..., an} = lcm{a1, lcm{a2, ... } ... }

use Lib::NumberTheory;

my $lcm = 1;
for my $i (1..20) {
	$lcm = Lib::lcm($i, $lcm);
}
print "$lcm\n";
