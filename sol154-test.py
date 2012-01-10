#!usr/bin/python

import math
import sys

testdepth = 200000
primes = [ (5, 12) , (2, 12) ]
def out(depth, primes):
	plen = dict( (p, int(math.log(testdepth) / math.log(p))) for (p, c) in primes )
	n_p = dict( (p, sumpow(depth, p, plen[p])) for (p, c) in primes)
	t = 0
	ot = 0
	skip = False
	max_r = depth / 2
	hack_r = depth % 2 == 0 # Do we need to hack on the last row of the upper triangle?
	print max_r, hack_r
	third_total = 0
	third_set = False
	for r in range(0,depth+1):
		r_p = dict()
		for (p, pc) in primes:
			rs_p = [ a - b for (a, b) in zip(sumpow(depth-r, p, plen[p]), n_p[p]) ]
			maxmissing = plen[p] * 2 - pc
			missing = 0
			got = 0
			d = p
			for x in rs_p:
				count = -(-(x + min(r, d-1)) / d)
				if count > 0:
					got += count
					if got >= pc:
						break
				if count < 2:
					missing += 2 - count
					if missing > maxmissing:
						break
				d *= p
			if missing > maxmissing or got < pc:
				skip = True
				break
			r_p[p] = rs_p
		if skip:
			skip = False
			continue
		nexts = dict( (p, -1) for (p, c) in primes )
		results = dict()
		if r > max_r:
			if hack_r:
				c = r - max_r + 1
			else:
				c = r - max_r
		else:
			c = 0
		max_c = r / 2
		ot = t
		if not third_set and r > max_r:
			third_total = t
			third_set = True
		while c <= max_c:
			min_next = max_c - 1
			for (p, pc) in primes:
				if c >= nexts[p]:
					nexts[p], results[p] = check(r_p[p], c, p, pc)
				if results[p] == False:
					c = nexts[p]
					skip = True
					continue
				else:
					min_next = min(min_next, nexts[p])
			if skip:
				skip = False
				continue
			if c == max_c and c * 2 == r:
				t += 1
			elif c == 0 and r == max_r and hack_r:
				t += 1
			else:
				t += 2
			if c >= min_next:
				c += 1
			else:
				t += (min_next - c - 1) * 2
				c = min_next
		print r, t-ot, t
	print t
	t += third_total * 2
	print t
	return t

def check(r, c, p, minhit):
	got = 0
	d = p
	clearance_y = []
	clearance_n = []
	for x in r:
		remain = c % d
		if x + remain <= 0:
			if d - 1 + x > 0:
				clearance_n.append(-(x + remain) + 1)
		elif x + remain <= d:
			if d - 1 + x > d:
				clearance_n.append(d-(x + remain) + 1)
			clearance_y.append(d - remain)
			got += 1
		else:
			clearance_y.append(d - remain)
			got += 2
		d *= p
	if got >= minhit:
		ret = True
		space = got - minhit
		clearance = clearance_y
	else:
		ret = False
		space = minhit - got - 1
		clearance = clearance_n
	if space >= len(clearance):
		nxt = c + 100000
	else:
		clearance.sort()
		nxt = c + clearance[space]
	return nxt, ret
			
def sumpow(n, r, m):
	d = r
	sp = []
	for x in range(m):
		sp += [ n % d ]
		d *= r
	return sp

if __name__ == "__main__":
	out(testdepth, primes)
	print asgasfd
	for depth2 in range(0, testdepth + 1):
		tr = [[1]]
		t1 = out(depth2, primes)
		for depth in range(depth2):
			tr += [[0] * (len(tr) + 1)]
			for mrow in range(0,len(tr)-1):
				row = len(tr)-mrow-1
				tr[row][0] += tr[row-1][0]
				for col in range(1, row):
					tr[row][col] += tr[row-1][col] + tr[row-1][col-1]
				tr[row][row] += tr[row-1][row-1]

		t = 0
		for i in tr:
			print " " * (len(tr) - len(i)),
			for j in i:
				skip = False
				for (p, pc) in primes:
					if j % p**pc != 0:
						skip = True
						break
				if not skip:
					t += 1
					print "#",
				else:
					print "O",
			print
		print t
		if t1 != t:
			print "FAIL", depth2
			break
