public final class CsvString implements CsvObject {
    private final String value;

    public CsvString(String value) {
        this.value = value;
    }

    public String getValue() {
        return this.value;
    }

    @Override
    public String toString() {
        return this.value;
    }
}

