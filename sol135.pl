# Using the method on Dario Alpern's solver to solve x^2 - y^2 = F:
# We have (x+y)(x-y)=F so x+y and x-y divide F.
# If F=uv then x+y=u and x-y=v.
# Then x=(u+v)/2 and y=(u-v)/2.
# Thus either u and v are both even or both odd, and u>v.
# Now x=y+i=z+2i so x-y=i=v and x+y=u=2x-i
# Thus:
#   F=i(2x-i)=n+z^2=n+x^2-4ix+4i^2
#   and n+x^2=i(2x-i+4x-4i)=i(6x-5i)
# So i divides n+x^2. i divides n if and only if i divides x.
# x^2-y^2-z^2=-x^2+2ix+4ix-5i^2=6ix-x^2-5i^2=(5i-x)(x-i)=n
# or y(4i-y)=n or (3i-z)(i+z)=n
# Therefore if n=uv then 5i-x=u and x-i=v so i=(u+v)/4 and x=(u+5v)/4=i+v
use strict;
use warnings;
my $target = 1000000;
my @seive;
my @fails;
my @sols = ((0) x $target+1);
for(my $z = 1; $z <= $target; $z++) {
	my $mini = int($z/3)+1; # i > z/3
	my $n = (3*$mini-$z)*($mini+$z);
	#(3i+3-z)(i+1+z)-(3i-z)(i+z)=3*(i+1+z)+(3i+3-z)+3=6i+2z+9
	#off-by-one error gives the -3 instead of +3
	for(my $i4 = 6*$mini+2*$z-3; $n <= $target; $i4+=6, $n+=$i4) {
#		my $i = ($i4-2*$z+3)/6;
#		my $y=$z+$i;
#		my $x=$y+$i;
#		print "$x $y $z $i $n\n";
		$sols[$n]++;
	}
}
my $sols = grep { $_ && $_ == 10 } @sols;
print "$sols\n";

=cut
# Previous attempt...
# It's almost right, but it seems to miss a few solutions, and is slower anyway.
# I'm sick of looking at it, so...
# Thus the power of 2 that divides n must not be 1 or 3.
# Also x-2i = (3v-u)/4 > 0 so 3v > u
# x(u)=x(u') implies u+5v=u'+5v'=uf+5v/f
# Make a seive of largest prime factors.
for my $f (2..int(sqrt($target))) {
	next if $seive[$f];
	for(my $n=$f*2; $n<=$target; $n+=$f) {
		$seive[$n]||=[];
		push @{$seive[$n]}, $f;
	}
}
my $count = 0;
outer: for my $n (2..$target) {
	if (!$seive[$n]) {
		next;
	}
	next if $n % 2 == 0 && $n % 4 != 0;
	next if $n % 8 == 0 && $n % 16 != 0;
	my (@divisors, @counts) = @{$seive[$n]};
	my $k = $n;
	my $divisors = 1;
	for(@divisors) {
		my $c=0;
		$k/=$_,$c++ while $k % $_ == 0;
		my $p = $_;
		if ($_ == 2) {
			$divisors *= $c==2?1:$c-3;
		} else {
			$divisors *= $c+1;
		}
		push @counts, $c;
	}
	# Now we need to check all divisors.
#	next if $divisors < 10;
	my $total=0;
	my %counter;
	if (check($n, 1, \@divisors, \@counts, \$total, \%counter) && $total == 10) {
		$count++;
	}
}
print "$count\n";
sub check {
	my ($nd, $d, $divisors, $count, $total, $counter) = @_;
	if (@$divisors == 0) {
		if (($nd+$d)%4 == 0) {
			my $i = ($nd+$d)/4;
			my $x = $i+$nd;
			my $y = $x-$i;
			my $z = $x-2*$i;
			print "Fail $x^2-$y^2-$z^2!=$nd*$d\n" if $x**2-$y**2-$z**2!=$nd*$d;
			print "$x $i ".($nd*$d)."\n";
			${$total}++ if $x - 2*$i > 0 && !$counter->{"$x $i"};
			print "Hit\n" if $counter->{"$x $i"};
			$counter->{"$x $i"} = 1;
#			${$total}++ if $nd != $d;
		}
		return if ${$total} > 10;
		return 1;
	}
	my $div = pop @$divisors;
	my $cnt = pop @$count;
	my $f = 1;
	my $end = $cnt;
	if ($div == 2) {
		if ($cnt == 2) {
			# 4 never divides 4p+q
			$f = $div;
			$end = 0;
		} else {
			# 4 never divides p+2^nq or 2p+2^nq
			$f = $div*$div;
			$end = $cnt-4;
		}
	}
	for(0..$end) {
#		if (3*$nd/$f > $d*$f) {
			return unless check($nd/$f, $d*$f, $divisors, $count, $total, $counter);
#		} else {
#			last;
#		}
		$f *= $div;
	}
	push @$divisors, $div;
	push @$count, $cnt;
	return 1;
}
exit;
