# At each stage, compute the chances of drawing exactly n blue discs.
# Since P[got n]P[draw red] is indept of P[got n-1]P[draw blue] there's no
# messy addition of dependent variables.

my $target = 15;
my @probs = (1);
for my $turns (1..$target) {
	my @nprobs;
	my $newprob = 1/($turns+1);
	$nprobs[0] = $probs[0] * (1 - $newprob);
	$nprobs[$turns] = $probs[$turns-1] * $newprob;
	for my $hits (1..$turns-1) {
		$nprobs[$hits] = $newprob * $probs[$hits-1] + (1-$newprob)*$probs[$hits];
	}
	@probs = @nprobs;
}
my $sum = 0;
for(int(($target+2)/2)..$target) {
	$sum += $probs[$_];
}
print int(1/$sum)."\n";
