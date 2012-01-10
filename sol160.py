#!/usr/bin/python

# Abuse the fact that we nevver get a trailing zero when multiplying by a
# number which doesn't divide by 2 or 5 -- and there's more 2s, so just
# ignore multiples of 5, 25, 125, 625, ...

def modprod(L, mod):
	p = 1
	for x in L:
		p = (p * x) % mod
	return p
def badlog(n, b):
	x = 1
	l = 0
	while x <= n:
		x *= b
		l += 1
	return l-1
def solve(n, mod):
	rem = 0
	prod = 1
	pow5 = badlog(n, 5)
	while pow5 >= 0:
		count = n / 5 ** pow5
		remcount = count - count/5
		rem, val = funkyfac(count, rem + pow5 * remcount, mod)
		prod = (prod * val) % mod
		pow5 -= 1
	return prod
def funkyfac(n, rem2, mod):
	key = (n, rem2)
	rem2, val1 = modpowfac(n/mod, rem2, mod)
	rem2, val2 = modfac(n%mod, rem2, mod)
	prod = (val1 * val2) % mod
	return rem2, prod
def modpowfac(n, rem2, mod):
	key = (n, rem2)
	pow2 = 2 ** badlog(n, 2)
	prod = 1
	while pow2 > 0:
		if n > pow2:
			rmul = pow2
			r, v = modfac(mod, rem2 / rmul + 1, mod)
			v = rsq(pow2, v, mod)
			rem2 -= (rem2/rmul + 1 - r) * rmul
			if rem2 < 0:
				prod *= 2 ** -rem2
				rem2 = 0
			prod = (prod * v) % mod
			n -= pow2
		pow2 /= 2
	return rem2, prod
def rsq(pow2, n, mod):
	val = n
	while pow2 > 1:
		n = (n * n) % mod
		pow2 /= 2
	return n
cache = dict()
def modfac(n, rem2, mod):
	key=(n,rem2)
	if key in cache:
		return cache[key]
	prod = 1
	for i in range(1,n+1):
		if i % 5 == 0:
			continue
		while rem2 > 0 and i % 2 == 0:
			i /= 2
			rem2 -= 1
		prod = (prod*i) % mod
	cache[key] = (rem2, prod)
	return (rem2, prod)
print solve(10**12,10**5)
