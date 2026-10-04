import java.awt.*;

public class SettingsMenu extends Panel {
    private final GridLayout layout;
    private final Label label;
    private final Checkbox definitionChechbox;
    private final Checkbox additionCheckbox;
    private final Checkbox actionCheckbox;
    private final Scrollbar fontSizeScrollbar;
    private final Label fontSizeLabel;

    public SettingsMenu() {
        super();

        this.layout = new GridLayout(0, 1);
        this.label = new Label("Настройки");
        this.definitionChechbox = new Checkbox();
        this.additionCheckbox = new Checkbox();
        this.actionCheckbox = new Checkbox();
        this.fontSizeLabel = new Label();
        this.fontSizeScrollbar = new Scrollbar();

        setBackground(Color.lightGray);

        initElements();
        addElements();
    }


    private void initElements() {
        this.label.setFont(new Font(Font.MONOSPACED, Font.BOLD, 24));

        Font checkboxFont = new Font(Font.MONOSPACED, Font.BOLD, 20);
        this.definitionChechbox.setLabel("Определение");
        this.definitionChechbox.setFont(checkboxFont);
        this.definitionChechbox.setState(true);

        this.additionCheckbox.setLabel("Дополнение");
        this.additionCheckbox.setFont(checkboxFont);
        this.additionCheckbox.setState(true);

        this.actionCheckbox.setLabel("Действие");
        this.actionCheckbox.setFont(checkboxFont);
        this.actionCheckbox.setState(true);
        
        this.fontSizeLabel.setText("Размер шрифта: 16");
        this.fontSizeLabel.setFont(checkboxFont);

        this.fontSizeScrollbar.setValue(16);
        this.fontSizeScrollbar.setVisible(true);
        this.fontSizeScrollbar.setOrientation(Scrollbar.HORIZONTAL);
        this.fontSizeScrollbar.setMinimum(16);
        this.fontSizeScrollbar.setMaximum(96);
    }

    private void addElements() {
        add(this.label);
        add(this.fontSizeLabel);
        add(this.fontSizeScrollbar);
        add(this.definitionChechbox);
        add(this.additionCheckbox);
        add(this.actionCheckbox);
        setLayout(this.layout);
    }
}
