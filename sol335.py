#!/usr/bin/python

def sim(n):
	a = [1] * n
	c = 0
	b = 0
	while True:
		t = a[b]
		a[b] = 0
		c += 1
		for i in range(t):
			b = (b + 1) % n
			a[b] += 1
			if a[b] == n:
				return c+1

for a in range(1, 101):
	n=a
	print n, sim(n)
