# There's a library routine to generate them, so use that.
use Lib::Utils;
use Lib::Lists;
my $prim = Lib::hlast
	Lib::htake 1,
	Lib::hgrep { Lib::sum(@$_) == 1000 }
	Lib::pythagorean_triples;
print Lib::product(@$prim)."\n";
