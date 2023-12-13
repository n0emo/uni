import java.awt.*;
import java.awt.event.*;

import javax.swing.JTextPane;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;

public class PhraseGenFrame extends Frame {
    private final Button generateButton;
    private final BorderLayout layout;
    private final WordLists wordLists;
    private final JTextPane resultArea;
    private final Panel bottomPanel;
    private final SettingsMenu settingsMenu;

    public PhraseGenFrame(Dimension windowSize) {
        super();

        this.generateButton = new Button();
        this.layout = new BorderLayout();
        this.wordLists = new WordLists();
        this.resultArea = new JTextPane();
        this.bottomPanel = new Panel();
        this.settingsMenu = new SettingsMenu();

        initFrame(windowSize);
        initElements();
        addActionListeners();
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

        SimpleAttributeSet attribs = new SimpleAttributeSet();
        StyleConstants.setAlignment(attribs, StyleConstants.ALIGN_CENTER);
        StyleConstants.setFontSize(attribs, 48);
        StyleConstants.setFontFamily(attribs, Font.MONOSPACED);
        this.resultArea.setParagraphAttributes(attribs, true);
        this.resultArea.setText("\nНажмите кнопку \"Сгенерировать\"...");

        this.bottomPanel.setLayout(new BorderLayout());

    }

    private void addActionListeners() {
        this.generateButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                StringBuilder sb = new StringBuilder();
                sb.append('\n');
                if (settingsMenu.isDefinitionChecked()) {
                    sb.append(wordLists.getDefinition());
                    sb.append(' ');
                }
                sb.append(wordLists.getObject());
                sb.append(' ');
                if (settingsMenu.isAdditionChecked()) {
                    sb.append(wordLists.getAddition());
                    sb.append(' ');
                }
                if (settingsMenu.isActionChecked()) {
                    sb.append(wordLists.getAction());
                    sb.append(' ');
                    sb.append(wordLists.getSubject());
                }
                resultArea.setText(sb.toString());
            }
        });
    }

    private void addElements() {
        this.bottomPanel.add(this.generateButton, BorderLayout.CENTER);
        this.bottomPanel.add(this.settingsMenu, BorderLayout.LINE_END);

        add(this.resultArea, BorderLayout.CENTER);
        add(this.bottomPanel, BorderLayout.PAGE_END);
        add(this.wordLists, BorderLayout.PAGE_START);

    }
}
