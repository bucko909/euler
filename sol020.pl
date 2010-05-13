# Cheating using bigint, really, but whatever.
use Lib;
my $fac = Math::BigInt->new(1);
$fac *= $_ for 2..100;
print Lib::sum(split //, $fac)."\n";
