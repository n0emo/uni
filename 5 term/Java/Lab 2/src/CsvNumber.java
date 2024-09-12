public final class CsvNumber implements CsvObject {
    private final double value;

    public CsvNumber(double value) {
        this.value = value;
    }

    public double getValue() {
        return this.value;
    }

    @Override
    public String toString() {
        String s = String.format("%f", this.value);
        return s;
    }
}
