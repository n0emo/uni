import java.awt.*;

public class ColorSelector extends Panel {
    private final Label label;
    private final CheckboxGroup checkboxGroup;
    private final Checkbox colorListCheckbox;
    private final Checkbox colorHexCheckbox;
    private final Checkbox randomCheckbox;
    private final Choice colorChoice;
    private final TextField colorHexField;
    private final GridLayout layout;

    private final String[] colors;

    public ColorSelector() {
        this.label = new Label();
        this.checkboxGroup = new CheckboxGroup();
        this.colorListCheckbox = new Checkbox();
        this.colorHexCheckbox = new Checkbox();
        this.randomCheckbox = new Checkbox();
        this.colorChoice = new Choice();
        this.colorHexField = new TextField();
        this.layout = new GridLayout();

        this.colors = new String[]{
            "Красный", "Оранжевый", "Жёлтый",
            "Зелёный", "Голубой", "Синий",
            "Фиолетовый"
        };

        setLayout(this.layout);

        initElements();
        addElements();
    }

    private void initElements() {
        this.label.setText("Выберите цвет");

        this.colorListCheckbox.setLabel("Выбрать цвет из списка");
        this.colorListCheckbox.setCheckboxGroup(this.checkboxGroup);
        this.colorListCheckbox.setState(true);

        this.colorHexCheckbox.setLabel("Ввести код цвета");
        this.colorHexCheckbox.setCheckboxGroup(this.checkboxGroup);
        this.colorHexCheckbox.setState(false);

        this.randomCheckbox.setLabel("Случайный цвет");
        this.randomCheckbox.setCheckboxGroup(this.checkboxGroup);
        this.randomCheckbox.setState(false);

        for(String color : this.colors) {
            this.colorChoice.add(color);
        }

        this.layout.setRows(6);
        this.layout.setColumns(1);
    }

    private void addElements() {
        add(this.label);
        add(this.colorListCheckbox);
        add(this.colorChoice);
        add(this.colorHexCheckbox);
        add(this.colorHexField);
        add(this.randomCheckbox);
    }
}