#!/usr/bin/python

class a:
	bbs_s = 290797
def bbs():
	a.bbs_s = (a.bbs_s * a.bbs_s) % 50515093
	return a.bbs_s % 500

import heapq
from rbtree import rbtree
class fail_py:
	L = (0,0)
	def cmp(x,y):
		if x[2] == None:
			if x[0][0] == L[0]:
				xc = L
			else:
				raise Exception("Should not happen")
		elif y[2] == None:
			if y[0][0] == L[0]:
				yc = L
		else:
			diff = y[2][0] * (x[3] + x[2][1] * L[0]) - x[2][0] * (y[3] + y[2][1] * L[0])
			if diff == 0:
				# Intersect on L[0].
				ip = (x[3] + x[2][1] * L[0]) / float(x[2][0])
				if x[2][1] * y[2][0] == y[2][1] * x[2][0]:
					raise Exception("Should not happen")
				if ip >= L[1]:
					# Higher grad on top if we're post-match
					return x[2][1] * y[2][0] > y[2][1] * x[2][0]
				else:
					# Lower grad on top if we're pre-match
					return x[2][1] * y[2][0] < y[2][1] * x[2][0]
			else:
				# Whichever is on top is on top
				return cmp(diff,0)


def bentley_ottman(lines):
	cur_tree = rbtree(cmp=fail_py.cmp)
	mylines = list()
	invalid = dict()
	for l in lines:
		if l[0] > l[1]:
			l0, l1 = l[1], l[0]
		else:
			l0, l1 = l[0], l[1]
		g = (l1[0] - l0[0], l1[1] - l1[0])
		o = l0[1] - l0[0] * g[1]
		mylines.append((l0, l1, g, o))
	endpoints = sum([[(l[0],2,l), (l[1],0,l)] for l in mylines],[])
	heapq.heapify(endpoints)
	queue = endpoints
	while True:
		try:
			event = heapq.heappop(queue)
		except IndexError, e:
			break
		if event in invalid:
			continue
		fail_py.L = event[0]
		if event[1] == 2: # Start; addit
			cur_tree[event[2]] = None
			p = get_prev(cur_tree,event[2])
			n = get_next(cur_tree,event[2])
			rem_cross(queue,p,n)
			add_cross(queue,p,event[2])
			add_cross(queue,event[2],n)
		elif event[1] == 0: # End; killit
			del cur_tree[event[2]]
			p = get_prev(cur_tree,event[2])
			n = get_next(cur_tree,event[2])
			rem_cross(queue,p,event[2])
			rem_cross(queue,event[2],n)
			add_cross(queue,p,n)
		elif event[2] == 1: # Crossing; swap and add
			crossings.append(event[0])

			p = get_prev(cur_tree,event[2])
			n = get_next(cur_tree,event[3])

			rem_cross(queue,p,event[2])
			rem_cross(queue,event[3],n)

			# Sort order ensures we now swap.
			del cur_tree[event[2]]
			cur_tree[event[2]] = None

			add_cross(queue,p,event[3])
			add_cross(queue,event[2],n)
	return crossings

def add_cross(queue,first,last):
	pass
def rem_cross(queue,first,last):
	pass
def crossing(first,last):
	pass
	# Test > fail_py.L
	# Use l[2] == gy,gx, l[3] == offset

lines = [((bbs(),bbs()),(bbs(),bbs())) for i in range(5000)]
bentley_ottman(lines)
