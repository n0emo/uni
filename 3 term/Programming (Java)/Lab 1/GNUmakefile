javabin = /usr/lib/jvm/java-1.8.0-openjdk/bin
java = $(javabin)/java
javac = $(javabin)/javac
jar = $(javabin)/jar
args = 


Tux.jar: *.class
	@echo "Compiling jar file"
	$(jar) -cfvm Tux.jar Tux.mft *.class assets/tux.jpg

.PHONY: Tux.jar-no-mft
Tux.jar-no-mft: Tux.class
	@echo "Compiling jar file"
	$(jar) -cfve Tux.jar Tux Tux.class TuxCanvas.class assets/*

*.class: *.java
	@echo "Compiling java files"
	$(javac) *.java

.PHONY: run
run: Tux.jar
	@echo "Running Tux with $(args):"
	@$(java) -jar Tux.jar $(args)

.PHONY: clean
clean:
	@echo "Cleaning project directory."
	@rm *.class *.jar -f
