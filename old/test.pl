#!/usr/bin/perl -w
$kmax = 12000;
$tofind = $kmax - 1;
$total = 0;
foreach $j (2 .. $kmax + 1) { $found[$j] = 0; }
for ($N = 2; $tofind; ++$N) {
  $nf[$N] = 1; # number of ways to factorize N
  $S[$N][0] = ([($N, 1, [$N])]); # trivial factorization
  $ismin = 0;
  # test each potential factor of N
  for ($j = 2; $j ** 2 <= $N; ++$j) {
    if ($N % $j == 0) {
      foreach $f ($S[$N/$j]) {
        foreach $p (0 .. $nf[$N/$j]-1) {
          # One factorization for each factorization of N/j
          $a = $f->[$p];
          if ($a->[2] >= $j) {
            ($sum, $nfac) = ($a->[0]+$j, $a->[1]+1);
            $S[$N][$nf[$N]++] = ([($sum, $nfac, [$j, @{$a->[2]}])]);
            $k = $N - $sum + $nfac;
            if ($k <= $kmax && $found[$k] == 0) {
              $found[$k] = $ismin = 1;
			  print "$k -> $N ".join("*",$j,@{$a->[2]})."\n";
              --$tofind;
            }
          }
        }
      }
    }
  }
  if ($ismin) { $total += $N; }
}
print $total, "\n";
