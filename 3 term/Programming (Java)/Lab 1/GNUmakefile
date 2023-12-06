javabin = /usr/lib/jvm/java-1.8.0-openjdk/bin
java = $(javabin)/java
javac = $(javabin)/javac
jar = $(javabin)/jar

*.class: *.java
	@echo "Compiling java files"
	$(javac) *.java

Tux.jar: *.class
	@echo "Compiling jar file"
	$(jar) -cfvm Tux.jar Tux.mft *.class assets/tux.jpg

.PHONE: Tux.jar-no-mft
Tux.jar-no-mft: Tux.class
	@echo "Compiling jar file"
	$(jar) -cfve Tux.jar Tux Tux.class TuxCanvas.class

.PHONY: run
run: Tux.jar
	@echo "Running Tux:"
	@$(java) -jar Tux.jar 

.PHONY: clean
clean:
	@echo "Cleaning project directory."
	@rm *.class *.jar -f
