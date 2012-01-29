import java.math.*;
import java.util.*;

class sol66 {
	public static void main(String[] args) {
		int d;
		BigInteger mx = BigInteger.ZERO, md;
		for(d=1;d<=1000;d++){
			if(Math.sqrt(d)==Math.floor(Math.sqrt(d)))
				continue;
			BigInteger D,a0,oa,op,oq,oP,oQ,P,Q,a,p,q;
			D = BigInteger.valueOf(d);
			a0 = BigInteger.valueOf((long)Math.sqrt(d));
			oa = a0;
			op = oa;
			oq = BigInteger.ONE;
			oP = BigInteger.ZERO;
			oQ = BigInteger.ONE;
			P = oa;
			Q = D.subtract(oa.pow(2));
			a = a0.add(P).divide(Q);
			p = a.multiply(oa).add(BigInteger.ONE);
			q = a;
			HashMap h = new HashMap();
			long r = 1;
			while(true) {
				System.out.println("r = " + r + "; a = " + a + "; p/q = " + p + "/" + q + "; Q/P = " + Q + "/" + P + ";");
				if (p.pow(2).subtract(D.multiply(q.pow(2))).equals(BigInteger.ONE)) {
					if (p.compareTo(mx)>0) {
						mx = p;
						md = D;
						System.out.println("x = " + p + "; d = " + D);
					}
					break;
				}
				r++;
				BigInteger nP, nQ, na, np, nq;
				nP = a.multiply(Q).subtract(P);
				nQ = D.subtract(nP.pow(2)).divide(Q);
				na = a0.add(nP).divide(nQ);
				np = na.multiply(p).add(op);
				nq = na.multiply(q).add(oq);
				op = p; oq = q; oa = a; oQ = Q; oP = P;
				p = np; q = nq; a = na; Q = nQ; P = nP;

/*				String s = "" + Q + "/" + P;
				if (h.get(s) != null) {
					BigInteger[] arr = (BigInteger[])h.get(s);
					if (arr[0].mod(BigInteger.valueOf(2)).equals(BigInteger.ZERO)) {

						if (p.compareTo(p)) {
							break;
						}
					}
				}*/
			}
		}
	}
}
