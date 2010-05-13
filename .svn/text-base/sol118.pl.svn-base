# Use recursion. This is slooowwww. Pregenerating a tree of possible prime
# leading digits ought to be faster.
use Lib;

my @primes = Lib::flatten Lib::hclip { $_ <= 10**5 } Lib::primes;
my %prime = ( 1 => 0 );

sub extend_number {
#	print "extend_number(@_)\n";
	my ($min_l, $min_s, $c, $num, @list) = @_;
	my $tot = 0;
	return 0 if length $num > 4 && @list + length $num == 9;
	for(0..$#list) {
		my @new_l = @list[0..$_-1,$_+1..$#list];
		my $new_min_s = $min_s;
		$new_min_s-- if $min_s > $_;
		$tot += extend_number($min_l, $new_min_s, $c, $num.$list[$_], @new_l);
	}
	if (length($num) >= $min_l && is_prime($num)) {
		if (length $num <= @list) {
			$tot += extend_list(length $num, $min_s, [@$c, $num], @list);
		} elsif (@list == 0) {
			$tot++;
		}
	}
	return $tot;
}

sub is_prime {
	return $prime{$_[0]} if exists $prime{$_[0]};
	my $temp = $_[0];
	for(my $i=0; $primes[$i]**2 <= $temp; $i++) {
		return $prime{$temp} = 0 if $temp % $primes[$i] == 0;
	}
	return $prime{$temp} = 1;
}

sub extend_list {
#	print "extend_list(@_)\n";
	my ($min_l, $min_s, $c, @list) = @_;
	my $tot = 0;
	for(0..$#list) {
		my @new_l = @list[0..$_-1,$_+1..$#list];
		if ($min_s > $_) {
			if ($min_l < @list) {
				$tot += extend_number($min_l + 1, $_, $c, $list[$_], @new_l);
			}
		} else {
			$tot += extend_number($min_l, $_, $c, $list[$_], @new_l);
		}
	}
	return $tot;
}

my $s = extend_list(1, 0, [], 1, 2, 3, 4, 5, 6, 7, 8, 9);
print "$s\n";


