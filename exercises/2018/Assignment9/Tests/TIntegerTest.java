package javaapplication10;



public class TIntegerTest extends TNumberTest {

	
	public void testaddInteger() {
            	TInteger n = (TInteger) this.getInt(4).add(this.getInt(5));
                System.out.print(n.unwrap());
	}
	

	public void testaddFloat() {
		TFloat n = (TFloat) this.getInt(24).add(this.getFloat(3.9f));
		System.out.print(n.unwrap());
	}

		
}
