#!/usr/bin/python

cache_row = dict()
def row_c(length, bads = [], sofar = []):
	if length in (2,3):
		return [tuple(sofar + [length])]
	elif length > 3:
		key = (length, tuple(bads), tuple(sofar))
		if key in cache_row:
			return cache_row[key]
		if not bads:
			n = length == 4 and 3 or 4
		else:
			n = bads[0]
		if n == 2:
			bits = [3]
		elif n == 3:
			bits = [2]
		else:
			bits = [2, 3]
		ret = []
		for brick in bits:
			if length - brick < 2:
				continue
			newbads = list(bads)
			eaten = 0
			while newbads and eaten + newbads[0] < brick:
				eaten += newbads[0]
				newbads = newbads[1:]
			if newbads:
				newbads[0] -= brick - eaten
				if newbads[0] == 0:
					continue
			ret += row_c(length-brick, newbads, sofar + [brick])
		cache_row[key] = ret
		return ret
	else:
		return []

cache_W = dict()
def W(n, i, prev = tuple(), sofar = []):
	if i == 0:
		return 1
	else:
		key = (n, i, prev)
		if key in cache_W:
			return cache_W[key]
		tot = sum(W(n, i-1, x, sofar + [x]) for x in row_c(n, prev))
		cache_W[key] = tot
		return tot

print W(32, 10)
