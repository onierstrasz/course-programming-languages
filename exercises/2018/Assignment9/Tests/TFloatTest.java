package javaapplication10;

public class TFloatTest extends TNumberTest {

	
	public void testaddInteger() {
		TFloat n = (TFloat) this.getFloat(2.5f).add(this.getInt(3));
		System.out.println(n.unwrap());
	}
	
	
	public void testaddFloat() {
		TFloat n = (TFloat) this.getFloat(2.4f).add(this.getFloat(1.5f));
                System.out.println(n.unwrap());
	}
}
