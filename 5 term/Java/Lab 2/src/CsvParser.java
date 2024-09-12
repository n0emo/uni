import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

public final class CsvParser {
    private final BufferedReader reader;

    public CsvParser(Reader reader) {
        this.reader = new BufferedReader(reader);
    }

    public Csv parse() throws IOException {
        final List<CsvObject[]> rows = new ArrayList<>();
        String line;

        while((line = this.reader.readLine()) != null) {
            CsvObject[] row = parseLine(line);
            rows.add(row);
        }

        return new Csv(rows.toArray(new CsvObject[0][]));
    }

    private CsvObject[] parseLine(String line) {
        final List<CsvObject> objects = new ArrayList<>();
        final StringBuffer buf = new StringBuffer();
        boolean inQuotes = false;
        var iter = line.chars().iterator();

        while(iter.hasNext()) {
            final int c = iter.next();

            switch (c) {
                case '"': {
                    inQuotes = !inQuotes;
                } break;

                case ',': {
                    if (inQuotes) {
                        buf.appendCodePoint(c);
                    } else {
                        appendObject(objects, buf);
                    }
                } break;

                default: {
                    buf.appendCodePoint(c);
                } break;
            }
        }

        appendObject(objects, buf);
        return objects.toArray(new CsvObject[0]);
    }

    private void appendObject(List<CsvObject> objects, StringBuffer buf) {
        final String s = buf.toString().trim();

        CsvObject o;
        try {
            double value = Double.parseDouble(s);
            o = new CsvNumber(value);
        } catch (NumberFormatException e) {
            o = new CsvString(s);
        }

        objects.add(o);
        buf.setLength(0);
    }
}

