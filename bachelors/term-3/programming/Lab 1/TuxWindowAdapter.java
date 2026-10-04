import java.awt.event.*;

// Класс, отвечающий за обработку событий окна.
public class TuxWindowAdapter extends WindowAdapter {
    @Override
    public void windowClosing(WindowEvent e) {
        System.exit(0);
    }
}
