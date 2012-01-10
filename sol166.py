#!/usr/bin/python

w = 4

def pos(x,y):
	return x+4*y

coord = tuple(range(0,w))
maxc = w * w

checks = dict()
for x in coord:
	checks[tuple( pos(x, z) for z in coord )] = [0,0]
	for y in coord:
		checks[tuple( pos(z, y) for z in coord )] = [0,0]
checks[tuple( pos(z, z) for z in coord )] = [0,0]
checks[tuple( pos(z, 3-z) for z in coord )] = [0,0]

grid = list()
gcheck = list()
for x in coord:
	#grid.append(list())
	#gcheck.append(list())
	for y in coord:
		grid.append(0)
		gc_this = list()
		gc_this.append(checks[tuple( pos(x, z) for z in coord )])
		gc_this.append(checks[tuple( pos(z, y) for z in coord )])
		if x == y:
			gc_this.append(checks[tuple( pos(z, z) for z in coord )])
		elif x == 3-y:
			gc_this.append(checks[tuple( pos(z, 3-z) for z in coord )])
		gcheck.append(gc_this)

class a:
	count = 0
	target = None
def search(p):
	if p < 5:
		print p, a.count
		print grid
	if p == maxc:
		a.count += 1
		return

	mn = 0
	mx = 9
	gc_this = gcheck[p]
	if p >= w:
		for (t, c) in gc_this:
			mn = max(a.target - t - 9 * (w - c - 1), mn)
			mx = min(a.target - t, mx)
			if mn >= mx:
				break
	n = mn
	for data in gc_this:
		data[0] += n
		data[1] += 1
	while n <= mx:
		grid[p] = n
		if p == w-1:
			a.target = gc_this[0][0]
		search(p+1)
		for data in gc_this:
			data[0] += 1
		n += 1
	for data in gc_this:
		data[0] -= n
		data[1] -= 1
	n += 1

search(0)
print a.count
