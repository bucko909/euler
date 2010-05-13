# My original solution used a custom BigInt, so I feel I've morally solved it,
# too. To save time, if using a custom bigint, do it by continual squaring and
# multiply 2^512+2^256+2^128+...
use Lib;
my $n = Math::BigInt->new(2);
$n->bpow(1000);
print Lib::sum(split //, $n)."\n";
