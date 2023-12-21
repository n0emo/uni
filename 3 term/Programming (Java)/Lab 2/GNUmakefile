javabin = /usr/lib/jvm/java-1.8.0-openjdk-amd64/bin
java = java
javac = $(javabin)/javac
jar = $(javabin)/jar

class_files = WordLists.class\
			  SettingsMenu.class\
			  PhraseGenWindowAdapter.class\
			  PhraseGenFrame.class\
			  PhraseGen.class\
			  ColorSelector.class\

args = 

PhraseGen.jar: $(class_files)
	@echo "Compiling jar file"
	$(jar) -cfvm PhraseGen.jar PhraseGen.mft *.class

ColorSelector.class: ColorSelector.java
	$(javac) ColorSelector.java

WordLists.class: WordLists.java
	$(javac) WordLists.java

SettingsMenu.class: SettingsMenu.java
	$(javac) SettingsMenu.java

PhraseGenWindowAdapter.class: PhraseGenWindowAdapter.java
	$(javac) PhraseGenWindowAdapter.java

PhraseGenFrame.class: PhraseGenFrame.java
	$(javac) PhraseGenFrame.java

PhraseGen.class: PhraseGen.java
	$(javac) PhraseGen.java

# .PHONY: Tux.jar-no-mft
# Gui.jar-no-mft: Gui.class
# 	@echo "Compiling jar file"
# 	$(jar) -cfve Tux.jar Tux Tux.class TuxCanvas.class assets/*

.PHONY: run
run: PhraseGen.jar
	@java -version
	@echo "Running PhraseGen with $(args):"
	@$(java) -jar PhraseGen.jar $(args)

.PHONY: clean
clean:
	@echo "Cleaning project directory."
	@rm *.class *.jar -f
