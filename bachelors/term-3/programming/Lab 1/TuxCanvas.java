import java.awt.*;

// Класс, отвечающий за отрисовку изображения
public class TuxCanvas extends Canvas {
    Image _image;

    private Dimension _windowSize;
    private final boolean _printAuthor;
    private final boolean _drawReference;
    private final String author = "Шефнер А., гр. ИВБ-211";
    private final String theme = "Linux Tux";

    public TuxCanvas(boolean printAuthor, boolean drawReference) {
        _printAuthor = printAuthor;
        _drawReference = drawReference;
    }

    @Override
    public void paint(Graphics g) {
        Graphics2D graphics = (Graphics2D) g;
        _windowSize = new Dimension(getWidth(), getHeight());

        fillBackground(graphics);
        if (_drawReference) {
            drawReference(graphics);
        } else {
            drawTux(graphics);
        }
        if (_printAuthor) {
            drawAuthor(graphics);
        }
    }

    private void fillBackground(Graphics2D graphics) {
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, _windowSize.width, _windowSize.height);
    }

    private void drawAuthor(Graphics2D graphics) {
        graphics.setFont(new Font("Arial", Font.BOLD, 20));
        graphics.setColor(Color.BLACK);
        graphics.drawString("Автор: " + author, 5, 20);
        graphics.drawString("Тема: " + theme, 5, 45);
    }

    private void drawReference(Graphics2D graphics) {
        if (_image == null) {
            _image = getToolkit()
                    .getImage(getClass().getResource("assets/tux.jpg"))
                    .getScaledInstance(getWidth(), getHeight(), Image.SCALE_DEFAULT);
        }
        graphics.drawImage(_image, 0, 0, this);
    }

    private void drawTux(Graphics2D graphics) {
        drawArms(graphics);
        drawBody(graphics);
        drawHead(graphics);
        drawEyes(graphics);
        drawStomach(graphics);
        drawBeak(graphics);
        drawLegs(graphics);
    }

    private void drawArms(Graphics2D graphics) {
        graphics.setColor(Color.BLACK);
        fillPolygonRel(graphics, new int[] { 240, 90, 240 },
                new int[] { 505, 505, 400 }, 3);
        fillPolygonRel(graphics, new int[] { 1000 - 240, 1000 - 120, 1000 - 240 },
                new int[] { 490, 490, 400 }, 3);
        graphics.setColor(Color.DARK_GRAY);
        fillPolygonRel(graphics, new int[] { 240, 125, 240 },
                new int[] { 495, 495, 420 }, 3);
        fillPolygonRel(graphics, new int[] { 1000 - 240, 1000 - 150, 1000 - 240 },
                new int[] { 480, 480, 410 }, 3);
    }

    private void drawBody(Graphics2D graphics) {
        graphics.setColor(Color.BLACK);
        final int bodyWidth = 550;
        final int bodyHeight = 700;
        final int bodyX = 500 - bodyWidth / 2;
        final int bodyY = 500 - bodyHeight / 2;

        fillOvalRel(graphics, bodyX, bodyY, bodyWidth, bodyHeight);
    }

    private void drawHead(Graphics2D graphics) {
        graphics.setColor(new Color(155, 155, 155));
        final int width = 350;
        final int height = 250;
        final int x = 500 - width / 2;
        final int y = 300 - height / 2;

        fillOvalRel(graphics, x, y, width, height);
    }

    private void drawEyes(Graphics2D graphics) {
        graphics.setColor(new Color(242, 242, 242));
        fillOvalRel(graphics, 370, 220, 140, 165);
        fillOvalRel(graphics, 500, 275, 100, 105);
        graphics.setColor(Color.BLACK);

        fillOvalRel(graphics, 465, 300, 40, 40);
        fillOvalRel(graphics, 505, 320, 25, 30);
    }

    private void drawStomach(Graphics2D graphics) {
        graphics.setColor(Color.BLACK);
        final int bodyWidth = 550;
        final int bodyHeight = 700;
        final int bodyX = 500 - bodyWidth / 2;
        final int bodyY = 500 - bodyHeight / 2;

        final int highArcWidth = 420;
        final int highArcHeight = 710;
        final int highArcX = 500 - highArcWidth / 2;
        final int highArcY = 726 - highArcHeight / 2;

        final int stomachWidth = 340;
        final int stomachHeight = 490;
        final int stomachX = 500 - stomachWidth / 2;
        final int stomachY = 610 - stomachHeight / 2;

        graphics.setColor(new Color(180, 180, 180));
        fillArcRel(graphics, bodyX, bodyY, bodyWidth, bodyHeight, 220, 100);
        fillArcRel(graphics, highArcX + 1, highArcY - 1, highArcWidth,
                highArcHeight, 0, 180);
        graphics.setColor(new Color(230, 230, 230));
        fillOvalRel(graphics, stomachX, stomachY, stomachWidth, stomachHeight);
    }

    private void drawBeak(Graphics2D graphics) {
        final int width = 160;
        final int height = 160;
        final int x = 500 - width / 2;
        final int y = 435 - height / 2;

        graphics.setColor(new Color(250, 197, 3));
        fillArcRel(graphics, x, y, width, height, 60, 60);
    }

    private void drawLegs(Graphics2D graphics) {
        final int width = 220;
        final int height = 120;
        final int relX = 125;
        final int leftX = 500 - relX - width / 2;
        final int rightX = 500 + relX - width / 2;
        final int y = 830 - height / 2;

        graphics.setColor(new Color(245, 228, 0));
        fillOvalRel(graphics, leftX, y, width, height);
        fillOvalRel(graphics, rightX, y, width, height);
    }

    // Версия метода Graphics.fillOval с относительными координатами
    private void fillOvalRel(Graphics2D graphics, int x, int y, int x_rad,
            int y_rad) {
        graphics.fillOval(relativeX(x), relativeY(y), relativeX(x_rad),
                relativeY(y_rad));
    }

    // Версия метода Graphics.fillArc с относительными координатами
    private void fillArcRel(Graphics2D graphics, int x, int y, int x_rad,
            int y_rad, int startAngle, int angle) {
        graphics.fillArc(relativeX(x), relativeY(y), relativeX(x_rad),
                relativeY(y_rad), startAngle, angle);
    }

    // Версия метода Graphics.fillPolygon с относительными координатами
    private void fillPolygonRel(Graphics2D graphics, int[] xs, int[] ys,
            int points) {
        int[] newXs = new int[xs.length];
        int[] newYs = new int[ys.length];

        for (int i = 0; i < newXs.length; i++) {
            newXs[i] = relativeX(xs[i]);
        }

        for (int i = 0; i < newYs.length; i++) {
            newYs[i] = relativeY(ys[i]);
        }

        graphics.fillPolygon(newXs, newYs, points);
    }

    // Размер виртуального холста - 1000х1000.
    // Эти методы умножают координату на отношение
    // реального размера окна и 1000.
    private int relativeX(int x) {
        return (int) ((double) _windowSize.width / 1000.0 * (double) x);
    }

    private int relativeY(int y) {
        return (int) ((double) _windowSize.height / 1000.0 * (double) y);
    }
}
