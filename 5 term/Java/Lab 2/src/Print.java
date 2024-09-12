public class Print {
    public static void print(Object... messages) {
        for (Object m : messages) {
            System.out.print(m.toString());
        }
    }

    public static void println(Object... messages) {
        print(messages);
        System.out.println();
    }

    public static void fatalPrintln(Object... messages) {
        for (Object m : messages) {
            System.err.print(m.toString());
        }
        System.err.println();
        System.exit(1);
    }
}
