# Using library routine...

use Lib::NumberTheory;
use Lib::Utils;
my $prime = Lib::hlast Lib::htake 10001, Lib::primes;
print "$prime\n";
