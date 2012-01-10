#!/usr/bin/python

import math
import sys
def drs(n):
	return n-((n-1)/9)*9 # Thanks to Euler forum; below is fast enough, though.
	r=n
	while r>9:
		t=0
		while r>0:
			t += r % 10
			r = r / 10
		r = t
	return n
m=999999
vals = map(drs, range(0,m+1))
max_test = int(math.sqrt(m))
s = 0
for test in range(2,m+1):
	s += vals[test]
	if test > max_test:
		continue
	for mul in range(2,m/test+1):
		if vals[mul*test] < vals[test] + vals[mul]:
			vals[mul*test] = vals[test] + vals[mul]
print s
