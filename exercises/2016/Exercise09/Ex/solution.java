package ch.unibe.pl2016.type.number;

public class TFloat extends TNumber {
    
    private float value;
    
    public TFloat(float value) {
        this.value = value;
    }
    
    public TNumber times(TNumber number) {
        return number.timesFloat(this);
    }
    
    @Override
    public TFloat timesFloat(TFloat number) {
        return new TFloat(this.unwrap() * number.unwrap());
    }

    @Override
    public TFloat timesInteger(TInteger number) {
        return new TFloat(this.unwrap() * number.unwrap());
    }
    
    public float unwrap() {
        return this.value;
    }

}

package ch.unibe.pl2012.type.number;

public class TInteger extends TNumber {
    
    private int value;
    
    public TInteger(int value) {
        this.value = value;
    }

    public TNumber times(TNumber number) {
        return number.timesInteger(this);
    }

    @Override
    public TFloat timesFloat(TFloat number) {
        return new TFloat(this.unwrap() * number.unwrap());
    }

    @Override
    public TInteger timesInteger(TInteger number) {
        return new TInteger(this.unwrap() * number.unwrap());
    }
    
    public int unwrap() {
        return value;
    }

}

package ch.unibe.pl2012.type.number;

public abstract class TNumber {

    abstract public TNumber times(TNumber number);
    
    abstract public TNumber timesFloat(TFloat number);
    
    abstract public TNumber timesInteger(TInteger number);
}

