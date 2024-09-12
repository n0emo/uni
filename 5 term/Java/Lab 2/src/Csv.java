public final class Csv {
    private final CsvObject[][] table;

    public Csv(CsvObject[][] table) {
        this.table = table;
    }

    public CsvObject[][] getTable() {
        return this.table;
    }
}
