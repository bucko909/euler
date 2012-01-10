#!/usr/bin/python

import copy

pieces = [
		(0,(1,1),(1,0)),
		(0,(1,1),(0,1)),
		(0,(1,0),(1,1)),
		(1,(0,1),(1,1)),
		(0,(1,),(1,),(1,)),
		(0,(1,1,1)),
]

nextcache = dict()
def nextways(next3rows):
	key = chop0(next3rows)
	if key in nextcache:
		return nextcache[key]
	results = dict()
	_nextways(next3rows, 0, results, [])
	nextcache[key] = results
	return results
def _nextways(next3rows, row, results, mypieces):
	#print "next3rows(" + str(next3rows) + ", " + str(row) + ", " + str(results) + ")"
	if row >= len(next3rows[0]):
		key = chop1(next3rows)
		if key in results:
			results[key] += 1
		else:
			results[key] = 1
		return
	if next3rows[0][row] == 1:
		_nextways(next3rows, row+1, results, mypieces)
		return
	i = -1
	for piece in pieces:
		i += 1
		ret = fits(next3rows, row, piece)
		if ret:
			_nextways(ret, row+1, results, mypieces + [i])

def fits(next3rows, row, piece):
	if piece[0] > row:
		return
	if row + len(piece[1]) - piece[0] > len(next3rows[0]):
		return
	for x in range(1,len(piece)):
		for y in range(len(piece[1])):
			if piece[x][y] and next3rows[x-1][row+y-piece[0]]:
				return
	newbits = copy.deepcopy(next3rows)
	for x in range(1,len(piece)):
		for y in range(len(piece[1])):
			if piece[x][y]:
				newbits[x-1][row+y-piece[0]] = 1
	return newbits

def chop1(next3rows):
	return (tuple(next3rows[1]), tuple(next3rows[2]))
def chop0(next3rows):
	return tuple(map(tuple, next3rows))
def add1(next2rows):
	return [list(next2rows[0]), list(next2rows[1]), [0 for x in range(len(next2rows[0]))]]

excache = dict()
def expand(next2rows, cols = 2):
	key = (next2rows, cols)
	if key in excache:
		return excache[key]
	if cols == 0:
		return 1
	nextbits = add1(next2rows)
	if cols == 2:
		for i in range(len(nextbits[0])):
			nextbits[2][i] = 1
	s = 0
	for i in nextways(nextbits).items():
		e = expand(i[0], cols-1)
		s += i[1] * e
	excache[key] = s
	return s

def sol161():
	start = tuple([tuple([0 for x in range(9)]) for x in range(2)])
	return expand(start, 12)

print sol161()
