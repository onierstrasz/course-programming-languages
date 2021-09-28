package ch.unibe.pl2016.type.number.test;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import ch.unibe.pl2016.type.number.TFloat;

public class TFloatTest extends TNumberTest {

	@Test
	public void testTimesInteger() {
		TFloat n = (TFloat) this.getFloat(2.5f).times(this.getInt(3));
		assertEquals(n.unwrap(), 7.5f, DELTA);
	}
	
	@Test
	public void testTimesFloat() {
		TFloat n = (TFloat) this.getFloat(2.4f).times(this.getFloat(1.5f));
		assertEquals(n.unwrap(), 3.6f, DELTA);
	}
}
