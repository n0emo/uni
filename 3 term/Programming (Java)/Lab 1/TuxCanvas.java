import java.awt.*;

public class TuxCanvas extends Canvas {
    Image _image;

    private final Dimension _windowSize;
    private final String author = "Шефнер А., гр. ИВБ-211";
    private final String theme = "Linux Tux";

    private final Color _testColor = new Color(255, 0, 255);

    public TuxCanvas(Dimension windowSize) {
        _windowSize = windowSize;
        _image = getToolkit()
                .getImage("assets/tux.jpg")
                .getScaledInstance(_windowSize.width, _windowSize.height,
                        Image.SCALE_DEFAULT);
    }

    @Override
    public void paint(Graphics graphics) {
        drawImage(graphics);
        // drawTux(graphics);
        drawAuthor(graphics);
    }

    private void drawAuthor(Graphics graphics) {
        graphics.setFont(new Font("Arial", Font.BOLD, 20));
        graphics.setColor(Color.BLACK);
        graphics.drawString("Автор: " + author, 5, 20);
        graphics.drawString("Тема: " + theme, 5, 45);
    }

    private void drawImage(Graphics graphics) {
        graphics.drawImage(_image, 0, 0, this);
    }

    private void drawTux(Graphics graphics) {
        graphics.setColor(_testColor);
        graphics.fillOval(250, 100, 600, 600);
    }
}
