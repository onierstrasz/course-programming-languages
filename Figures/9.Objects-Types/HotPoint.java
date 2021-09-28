class Point {
	private int x, y;
	Point(int x, int y) { this.x = x; this.y = y; }
	int getX() { return x; }
	int getY() { return y; }
	boolean equals(Point other) {
		return (this.getX() == other.getX()) && (this.getY() == other.getY());
	}
}

class HotPoint extends Point {
	private boolean on = false;
	HotPoint(int x, int y) { super(x, y); }
	void toggle() { on = !on; }
	boolean getOn() { return on; }
	boolean equals(HotPoint other) {
		return super.equals(other) && (this.getOn() == other.getOn());
	}
}

class Main {
	public static void main(String args[]) {
		HotPoint hotpt1, hotpt2;

		hotpt1 = new HotPoint(3, 5);
		hotpt2 = new HotPoint(3, 5);
		hotpt2.toggle();

		// System.out.println(hotpt1.toString() + " is " + (hotpt1.equals(hotpt2) ? "" : "not ") + "the same as " + hotpt2);
		compare(hotpt1, hotpt2);
	}

	private static void compare(Point pt1, Point pt2) {
		System.out.println(pt1.toString() + " is " + (pt1.equals(pt2) ? "" : "not ") + "the same as " + pt2);
	}
}