#As most of the tools for computing square roots are available to us, just use them.

(echo scale=100; for I in `seq 1 100`; do echo "sqrt($I)"; done)|bc -l|perl -pe 's/\\\n//'|grep -v '0000$'|grep '....'|perl -ne 's/\.//;@a=split //;@a=@a[0..99];$s+=$_ for@a;print"$s\n"'|tail -n 1
