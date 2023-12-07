import java.awt.*;

public class Tux {
    private static final Dimension _windowSize = new Dimension(1000, 1000);

    public static void main(String[] args) {
        boolean printAuthor = !arrayContains(args, "-n");
        boolean drawReference = arrayContains(args, "-r");

        Canvas canvas = new TuxCanvas(printAuthor, drawReference);

        Frame frame = new Frame();
        frame.add(canvas);
        frame.setSize(_windowSize);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
        frame.addWindowListener(new TuxWindowAdapter());
    }

    private static <T> boolean arrayContains(T[] array, T elem) {
        for (T e : array) {
            if (elem.equals(e)) {
                return true;
            }
        }
        return false;
    }
}
