import java.text.DecimalFormat;

public class Main {
    public static void main(String[] args) {
        if (args.length == 0) {
            return;
        }

        final float[] numbers;
        try {
            numbers = parseFloatArray(args);
        } catch (NumberFormatException e) {
            fatalPrintln("Error reading numbers: ", e.getMessage());
            return; // Java thinks that this function does not exits after System.exit
        }

        try {
            quickSort(numbers);
        } catch (IllegalArgumentException e) {
            fatalPrintln(e.getMessage());
        }

        printArray(numbers);
    }

    private static float[] parseFloatArray(String[] strings) throws NumberFormatException {
        final float[] floats = new float[strings.length];
        for (int i = 0; i < strings.length; i++) {
            floats[i] = Float.parseFloat(strings[i]);
        }
        return floats;
    }

    private static void printArray(float[] array) {
        final DecimalFormat format = new DecimalFormat("#.#####");
        print(format.format(array[0]));
        for (int i = 1; i < array.length; i++) {
            print(", ", format.format(array[i]));
        }
        println();
    }

    private static void print(Object... messages) {
        for (Object m : messages) {
            System.out.print(m.toString());
        }
    }

    private static void println(Object... messages) {
        print(messages);
        System.out.println();
    }

    private static void fatalPrintln(Object... messages) {
        for (Object m : messages) {
            System.err.print(m.toString());
        }
        System.err.println();
        System.exit(1);
    }

    private static void quickSort(float[] array) throws IllegalArgumentException {
        quickSort(array, 0, array.length);
    }

    private static void quickSort(float[] array, int start, int end) throws IllegalArgumentException {
        if (end - start <= 1) {
            return;
        }

        if (end < 0 || end > array.length || start < 0 || start >= array.length) {
            throw new IllegalArgumentException(
                "Attempt to sort an array outside of the boundaries ("+
                "start=" + start + ", " +
                "end=" + end + ", " +
                "array.length=" + array.length + ")");
        }

        final float pivot = array[end - 1];
        int left = start;
        int right = start;

        while(right < end - 1) {
            if (array[right] < pivot) {
                float tmp = array[left];
                array[left] = array[right];
                array[right] = tmp;
                left++;
            }

            right++;
        }

        array[end - 1] = array[left];
        array[left] = pivot;

        quickSort(array, start, left);
        quickSort(array, left + 1, end);
    }
}
