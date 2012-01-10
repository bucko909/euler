#!/usr/bin/python

# Choose a pivot point, and just work out the number of arrangements on each
# side.

def fac(n):
	r=1
	for i in range(1,n+1):
		r *= i
	return r
def ncr(n,r):
	return fac(n) / (fac(r) * fac(n-r))

m = 0
ml = -1
for l in range(2, 27):
	#len(string) == l
	s = 0
	for p in range(l-1):
		#string[p] is minimum
		for c in range(26-p-1):
			# l = 2 ==> c in (0, ..., 24)
			#string[p] == c
			#So 25-c remain
			priors = ncr(25-c, p)
			above_c_count = 26 - (c+1) - p
			# min extra is #remain - c
			for extra in range(max(0,l-p-2-c),above_c_count): # TODO
				# Above c + below c
				choose_from = extra + c
				t = priors * ncr(choose_from, l-p-2)
				s += t
	if s > m:
		m = s
		ml = l
print m
