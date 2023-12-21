import java.awt.*;

public class PhraseGenFrame extends Frame {
    private final Button generateButton;
    private final BorderLayout layout;
    private final WordLists wordLists;
    private final TextArea resultArea;
    private final SettingsMenu settingsMenu;
    private final ColorSelector colorSelector;
    private final FontSizeSelector fontSizeSelector;

    public PhraseGenFrame(Dimension windowSize) {
        super();

        this.generateButton = new Button();
        this.layout = new BorderLayout();
        this.wordLists = new WordLists();
        this.resultArea = new TextArea();
        this.settingsMenu = new SettingsMenu();
        this.colorSelector = new ColorSelector();
        this.fontSizeSelector = new FontSizeSelector();

        initFrame(windowSize);
        initElements();
        addElements();
    }

    private void initFrame(Dimension windowSize) {
        setSize(windowSize);
        setLocationRelativeTo(null);
        setTitle("Linux Gui");
        addWindowListener(new PhraseGenWindowAdapter());
        setLayout(this.layout);
    }

    private void initElements() {
        this.generateButton.setLabel("Сгенерировать");
        this.generateButton.setFont(new Font(Font.MONOSPACED, Font.BOLD, 72));
        this.generateButton.setBackground(Color.green);

        this.resultArea.setText("\nНажмите кнопку \"Сгенерировать\"...");
        this.resultArea.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 16));
    }

    private void addElements() {
        add(this.resultArea, BorderLayout.CENTER);
        add(this.generateButton, BorderLayout.PAGE_END);
        add(this.wordLists, BorderLayout.PAGE_START);

        add(this.colorSelector, BorderLayout.LINE_START);
        add(this.settingsMenu, BorderLayout.LINE_END);

    }
}
