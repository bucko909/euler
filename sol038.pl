# length 1: The given product /must/ be the maximum.
# length 2: Can get 8 (x<25), 9 (25<=x<50) or more. But the length 9 starts
# with 2 so is too low.
# length 3: Can get 9 (x<333), but again it'll be too low.
# length 4: Can get 8 (x<5000) or 9 (x>=5000), so start at 9327.
# length 5: Too big
use Lib;
my $max = 932718654;
for(9327..9876) {
	my $x = $_*10000+$_*2;
	next if !Lib::is_pandigital_1($x);
	$max = $x if $max < $x;
}
print "$max\n";
