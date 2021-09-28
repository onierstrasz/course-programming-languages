package ch.unibe.pl2016.type.number.test;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import ch.unibe.pl2016.type.number.TFloat;
import ch.unibe.pl2016.type.number.TInteger;

public class TIntegerTest extends TNumberTest {

	@Test
	public void testTimesInteger() {
		TInteger n = (TInteger) this.getInt(2).times(this.getInt(3));
		assertEquals(n.unwrap(), 6);
	}
	
	@Test
	public void testTimesFloat() {
		TFloat n = (TFloat) this.getInt(2).times(this.getFloat(3.5f));
		assertEquals(n.unwrap(), 7.0f, DELTA);
	}

		
}
