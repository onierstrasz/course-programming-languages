package javaapplication10;

public abstract class TNumberTest {
	
	public TInteger getInt(int n) {
		return new TInteger(n);
	}

	public TFloat getFloat(float n) {
              
		return new TFloat(n);
	}
}
