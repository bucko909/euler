#!/usr/bin/sh

m = 16
def numspecial(pickfrom, total, topick):
	if topick == 0:
		return pickfrom ** total
	s = 0
	for i in range(total-topick+1):
		n = numspecial(pickfrom, total-i-1, topick-1)
		s += (pickfrom-topick)**i * n
	return s
def fac(n):
	if n < 2:
		return 1
	return n * fac(n-1)

# generate all reversed numbers
base = 16
digits = 16
choose = 3 # 0, 1, A
def lengtheq(base, digits, choose):
	mul = fac(choose-1) * (choose - 1) # 0 can't be the first chosen digit
	zeronotfirst = mul * numspecial(base, digits, choose)
	zerofirst = fac(choose-1) * (base-choose) * numspecial(base, digits-1, choose)
	return zerofirst + zeronotfirst
def lengthgt(base, digits, choose):
	return sum(lengtheq(base, x, choose) for x in range(choose, digits+1))
print hex(lengthgt(base, digits, choose)).upper()
