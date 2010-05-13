# This is a horrible brute force solution.
# Generate all increasing sequences of digits, all permutations of said digits,
# all sets of 3 operations and all postfix positions to apply them. Then
# evaluate everything.
use Lib;
my @nums = (0, 0, 0, 0);
my $count = 0;
my $max = 0;
my $maxr;
while(1) {
	Lib::listinc_shortlex_increasing {
		return if @{$_[0]} > 4;
		return if $_[0][$#{$_[0]}] > 9;
		return 1;
	} \@nums;
	$count++;
	last if @nums > 4;
	my @hit;
	my @order = (0, 0, 0);
	while(1) {
		my @list = @nums;
		my @nums2;
		for(reverse @order) {
			push @nums2, splice @list, $_, 1;
		}
		push @nums2, @list;
		my @ops = (0, 0, 0);
		while(1) {
			my @oppos = (0, 0);
			math:while(1) {
				Lib::listinc_shortlex {
					return if @{$_[0]} > 2;
					return if $_[0][1] > 2;
					return if $_[0][0] > 1;
					return 1;
				} \@oppos;
				last if @oppos > 2;
				my @vals = @nums2;
				for(0..2) {	
					# %3 to get undef==0 for 2
					my $pos = $oppos[(1-$_)%3];
					if ($ops[$_] == 0) {
						splice @vals, $pos, 2, $vals[$pos] + $vals[$pos+1];
					} elsif ($ops[$_] == 1) {
						splice @vals, $pos, 2, $vals[$pos] - $vals[$pos+1];
					} elsif ($ops[$_] == 2) {
						splice @vals, $pos, 2, $vals[$pos] * $vals[$pos+1];
					} else {
						next math if $vals[$pos+1] == 0;
						splice @vals, $pos, 2, $vals[$pos] / $vals[$pos+1];
					}
				}
				$hit[$vals[0]] = 1 if $vals[0] > 0 && $vals[0] == int($vals[0]);
			}
			Lib::listinc_shortlex {
				return if @{$_[0]} > 3;
				return if $_[0][2] > 3;
				return if $_[0][1] > 3;
				return if $_[0][0] > 3;
				return 1;
			} \@ops;
			last if @ops > 3;
		}
		Lib::listinc_shortlex {
			return if @{$_[0]} > 3;
			return if $_[0][2] > 3;
			return if $_[0][1] > 2;
			return if $_[0][0] > 1;
			return 1;
		} \@order;
		last if @order > 3;
	}
	my $top = 0;
	for(1..$#hit) {
		last unless $hit[$_];
		$top = $_;
	}
	if ($top > $max) {
		$maxr = join '', @nums;
		$max = $top;
	}
}
print "$maxr\n";
