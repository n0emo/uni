import java.awt.*;
import java.awt.event.*;
import java.util.Random;

public class WordLists extends Panel {
    public class RandomButtonActionListener implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            randomizeListSelection(definitionList);
            randomizeListSelection(objectList);
            randomizeListSelection(additionList);
            randomizeListSelection(actionList);
            randomizeListSelection(subjectList);
        }
    }

    private final String[] definitions = { "Крутой", "Большой", "Интересный", "Сверхестественный", "Мощный",
            "Космический" };
    private final String[] objects = { "верблюд", "карандаш", "омлет" };
    private final String[] additions = { "чести", "деревни", "волшебства" };
    private final String[] actions = { "создаёт", "уничтожает", "изучает" };
    private final String[] subjects = { "обряд", "магазин", "инструмент" };

    private final List definitionList;
    private final List objectList;
    private final List additionList;
    private final List actionList;
    private final List subjectList;

    private final GridLayout layout;

    private final Button randomButton;

    private final Random random;

    public WordLists() {
        this.definitionList = new List();
        this.objectList = new List();
        this.additionList = new List();
        this.actionList = new List();
        this.subjectList = new List();
        this.randomButton = new Button();
        this.layout = new GridLayout(1, 0);
        this.random = new Random();

        setLayout(layout);

        initElements();
        addElements();

        this.randomButton.addActionListener(new WordLists.RandomButtonActionListener());
    }

    public String getDefinition() {
        return definitionList.getSelectedItem();
    }

    public String getObject() {
        return objectList.getSelectedItem();
    }

    public String getAddition() {
        return additionList.getSelectedItem();
    }

    public String getAction() {
        return actionList.getSelectedItem();
    }

    public String getSubject() {
        return subjectList.getSelectedItem();
    }

    private void randomizeListSelection(List list) {
        int selection = random.nextInt(list.getItemCount());
        list.select(selection);
    }

    private void initElements() {
        populateList(definitionList, definitions);
        populateList(objectList, objects);
        populateList(additionList, additions);
        populateList(actionList, actions);
        populateList(subjectList, subjects);

        definitionList.select(0);
        objectList.select(0);
        additionList.select(0);
        actionList.select(0);
        subjectList.select(0);

        this.randomButton.setLabel("Случайная комбинация");
    }

    private void addActionListeners() {
    }

    private void addElements() {
        add(definitionList);
        add(objectList);
        add(additionList);
        add(actionList);
        add(subjectList);
        add(this.randomButton);
    }

    private void populateList(List list, String[] items) {
        for (String item : items) {
            list.add(item);
        }
    }
}
