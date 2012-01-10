#!/usr/bin/python

cache = dict()
def count(digits, last1, last2):
	if digits == 0:
		return 1
	key = (digits, last1, last2)
	if key in cache:
		return cache[key]
	s = 0
	for n in range(0,10-last1-last2):
		s += count(digits-1, n, last1)
	cache[key] = s
	return s
print sum(count(19, n, 0) for n in range(1,10))
