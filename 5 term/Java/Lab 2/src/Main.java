import java.io.BufferedReader;
import java.io.FileReader;

public class Main {
    public static void main(String[] args) {
        if (args.length == 0) {
            usage();
            return;
        }

        final Csv csv;
        try (BufferedReader reader = new BufferedReader(new FileReader(args[0]))) {
            CsvParser parser = new CsvParser(reader);
            csv = parser.parse();
        } catch (Exception e){
            Print.fatalPrintln(e.getMessage());
            return;
        }

        var table = csv.getTable();

        for(int i = 0; i < table.length; i++) {
            double sum = 0;
            for(int j = 0; j < table[i].length; j++) {
                if (table[i][j] instanceof CsvNumber number) {
                    sum += number.getValue();
                } else {
                    Print.fatalPrintln("All cells must be numbers");
                }
            }

            sum /= (double) table[i].length;
            Print.println(i + 1, " row: ", sum);
        }
    }

    private static void usage() {
        Print.println("Usage: ./program <file>");
    }
}
