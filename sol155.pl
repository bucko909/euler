#!/usr/bin/perl

# The following one-liner just brute-forces the problem. It has to use
# rational reps due to annoying rounding problems.
#
# Everyone on the forum brute forced it, and it's not so interesting code,
# so I'm not going to fix it.

@n=([],[[1,1]]);my@l=(0,[0,1]);my$t=1;for$i(2..18){my@a;for$n(1..$i-1){$m=$i-$n;for$x(@{$n[$n]}){for$y(@{$n[$m]}){$tem=$x->[0]*$y->[1]+$y->[0]*$x->[1];for([$tem,$x->[1]*$y->[1]],[$x->[0]*$y->[0],$tem]){my($a,$b)=@$_;($a,$b)=($b,$a)if$a<$b;($a,$b)=($b,$a%$b)while$b;$_=[$_->[0]/$a,$_->[1]/$a];if(!$l[$_->[0]][$_->[1]]){$l[$_->[0]][$_->[1]]=1;push@a,$_;$t++}}}}}push@n,\@a}print"$t\n"
