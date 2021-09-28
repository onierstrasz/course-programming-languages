package ch.unibe.pl2016.type.number.test;


import ch.unibe.pl2016.type.number.TFloat;
import ch.unibe.pl2016.type.number.TInteger;

public abstract class TNumberTest {

	public final static float DELTA = 0.000001f;
	
	public TInteger getInt(int n) {
		return new TInteger(n);
	}

	public TFloat getFloat(float n) {
		return new TFloat(n);
	}
}
