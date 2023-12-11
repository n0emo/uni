import java.awt.*;

// Main класс, в котором находится логика создания окна.
public class Tux {
    private static final Dimension _windowSize = new Dimension(1000, 1000);

    public static void main(String[] args) {

        // Создание окна и добавление в него холста
        Frame frame = new Frame();
        frame.setSize(_windowSize);
        frame.setLocationRelativeTo(null);
        frame.setTitle("Linux Tux");
        frame.setVisible(true);
        frame.addWindowListener(new TuxWindowAdapter());
    }
}
