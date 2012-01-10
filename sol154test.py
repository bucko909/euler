#!usr/bin/python

import math
def out(tr, n):
	print "-" * (len(tr) * 2)
	n_r = sumpow(n+1, 2, 7)
	r = 0
	for row in tr:
		r_r = [ a - b for (a, b) in zip(sumpow(r+1, 2, 7), n_r) ]
		c = 0
		for val in row:
			c_r = sum(math.ceil(a + b) for (a, b) in zip(sumpow(c+1, 2, 7), r_r))
			print c_r, n, r, c, val
			c += 1
			oval = val
			#print "% 5i" % val,
			i=0
			while val and val % 2 == 0:
				val /= 2
				i += 1
			val = oval
			j=0
			while val and val % 5 == 0:
				val /= 5
				j += 1
			d = i == c_r
			print abs(i - c_r) < 2 and "#" or " ",
		print
		r += 1
	print "-" * (len(tr) * 2)
	print
			
def sumpow(n, r, m):
	d = r
	sp = []
	for x in range(m):
		sp += [ (n % d) / float(d) ]
		d *= r
	return sp

if __name__ == "__main__":
	tr = [[1]]
	out(tr, 0)
	for depth in range(1000):
		tr += [[0] * (len(tr) + 1)]
		for mrow in range(0,len(tr)-1):
			row = len(tr)-mrow-1
			tr[row][0] += tr[row-1][0]
			for col in range(1, row):
				tr[row][col] += tr[row-1][col] + tr[row-1][col-1]
			tr[row][row] += tr[row-1][row-1]
		out(tr, depth)
