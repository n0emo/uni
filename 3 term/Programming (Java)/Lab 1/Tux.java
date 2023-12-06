import java.awt.*;

public class Tux {
    private static final Dimension _windowSize = new Dimension(800, 800);

    public static void main(String[] args) {
        Canvas canvas = new TuxCanvas(_windowSize);

        Frame frame = new Frame();
        frame.add(canvas);
        frame.setSize(_windowSize);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
        frame.addWindowListener(new TuxWindowAdapter());
    }
}
