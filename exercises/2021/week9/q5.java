 private static class Automobile { }

    private static class Car extends Automobile {  }
    private static class Truck extends Automobile { }
    private static class Minicar extends Car { }

    public static void main(String[] args) {
        //-------------- Block1
        List<Car> list_of_cars = new ArrayList<>();
        list_of_cars.add(new Car());
        list_of_cars.add(new Car());
        list_of_cars.add(new Truck());
        list_of_cars.add(new Minicar());
        List<? extends Automobile> list_of_automobiles = list_of_cars;
        List<? extends Truck> list_of_automobiles = list_of_cars;
        list_of_automobiles.remove(0);
        System.out.println(list_of_automobiles);

        //--------------- Block2
        List<Number> list_of_ints = new ArrayList<>();
        list_of_ints.add(1);
        list_of_ints.add(2);
        List<? super Integer> list_of_numbers = list_of_ints;
        list_of_numbers.add(3);
        list_of_numbers.add(4.2);
        System.out.println(list_of_numbers);

        //------------- Block3
        List<Automobile> aList = new ArrayList<>();
        aList.add(new Automobile());

        List<? super Car> bList = aList;
        bList.add(new Car());
        bList.add(new Truck())
        bList.add(new Minicar());
        System.out.println(bList);
}