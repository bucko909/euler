# Search all products of 3 digit numbers for palindromes. Use a diagonal wedge
# so that it's possible to see when it's getting too small and cover elements
# faster.
use Lib::Lists;
use Lib::Utils;
my $max;
my $ans = Lib::hlast
	Lib::hgrep { $max = $_ if $_ > $max } # Drop anything that's too low
	Lib::hgrep { Lib::is_palindrome ($_) } # Only allow palindromic products
	Lib::hmap { $_->[0] * $_->[1] } # Get the product
	# For the lowest in each run, make sure it's not /too/ low.
	Lib::hclip { !$max || $_->[0] != $_->[1] || $_->[0] ** 2 >= $max }
	Lib::hwedge_diagonal # Search all distinct pairs
	Lib::promote(reverse 100..999); # Starting with the largest
print "$ans\n";
