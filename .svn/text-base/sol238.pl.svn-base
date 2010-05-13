# The following code verifies that the random number generator repeats after
# 2534198 iterations:
#perl -e '$_=14025256;do{$_=($_*$_)%20300713;$a++}while($_!=14025256);print "$a $_\n"'
#
# There will therefore be about 1.5*10^7 digits in a repeating string.
# By computing the sum N of digits in that substring, the 2*10^15 can be reduced
# to just N as the larger numbers will all start from a point before
# 1.5*10^7, and be of the form kN + i - we need only search for i.
#
# Even finding the i seems nontrivial however.
#
# Notably 20300713 = 4127 * 4919.
