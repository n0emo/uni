import java.awt.*;

// Main класс, в котором находится логика создания окна.
public class PhraseGen {
    private static final Dimension WINDOW_SIZE = new Dimension(900, 550);

    public static void main(String[] args) {
        // Создание окна и добавление в него холста
        Frame frame = new PhraseGenFrame(WINDOW_SIZE);
        frame.setVisible(true);
    }
}
