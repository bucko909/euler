# 1) Read file.
# 2) Eliminate non anagrams, and for each pair of anagrams, store once as
# word => word in a hash, and store the first in the pair in a list of
# anagrammable fords of its length.
# 3) Starting from the longest, generate all squares of this length, and
# cull any with repeated digits (this isn't strictly possible, but only EXPECT
# as a word violates this, and it has no valid square mappings anyway - I
# noticed the repeating digit clause after I'd solved without it, so I had the
# information).
# 4) Test all squares against all words to see if the mappings make a square
# when the word is anagrammed.
my @words;
open WORDS, "words.txt";
while($_ = <WORDS>) {
	s/\s*$//;
	push @words, /"([^",]+)"/g;
}
# First, find all the words that have anagrams...
# Preliminarily add up all ASCII values.
my %sums;
for(0..$#words) {
	my $sum = 0;
	$sum += ord($_) for split //, $words[$_];
	$sum = $sum * 100 + length($words[$_]);
	$sums{$sum} ||= [];
	push @{$sums{$sum}}, $words[$_];
}
# Now brute force anagram-ness.
my %anagrams; # word => word
my @awords; # length => word list
for my $candidates (values %sums) {
	next if @$candidates == 1;
	for (0..$#$candidates) {
		my $candidate = $candidates->[$_];
		test:for ($_+1..$#$candidates) {
			my $test = $candidates->[$_];
			next if $test eq $candidate;
			my @letters = ((0) x 255);
			$letters[ord$_]-- for split //, $test;
			$letters[ord$_]++ for split //, $candidate;
			for(@letters) {
				next test if $_;
			}
			$anagrams{$candidate} ||= [];
			push @{$anagrams{$candidate}}, $test;
			$awords[length$candidate] ||= [];
			push @{$awords[length$candidate]}, $candidate if $awords[length$candidate][$#{$awords[length$candidate]}] ne $candidate;
		}
	}
}
for(0..$#awords) {
	my $l = $#awords - $_;
	next unless @{$awords[$l]};
	# Generate all the square numbers of this length
	my @squares;
	my %square;
	for(int(sqrt(10**($l-1)))..int(sqrt(10**$l))) {
		my $square = $_**2;
		next if length($square) != $l;

		# Cheating way to solve repeating digits problem. It's not strictly
		# true that we can do this.
		my %digits;
		$digits{$_}++ for split //, $square;
		next if grep { $_ > 1 } values %digits; 

		push @squares, [ split //, $square ];
		$square{$square} = 1;
	}
	my $max;
	for my $first (@{$awords[$l]}) {
		my @lets = split //, $first;
		for my $second (@{$anagrams{$first}}) {
			my @lets2 = split //, $second;
			for my $square (@squares) {
				my %map;
				for my $dnum (0..$l-1) {
					$map{$lets[$dnum]} = $square->[$dnum];
				}
				my $new = join '', map { $map{$_} } @lets2;
				next if !$square{$new};
				if ($square > $max) {
					$max = join '', @$square;
				}
				if ($new > $max) {
					$max = $new;
				}
			}
		}
	}
	if ($max) {
		print "$max\n";
		last;
	}
}
