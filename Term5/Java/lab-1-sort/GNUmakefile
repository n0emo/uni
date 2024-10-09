SRC_DIR := src
OUT_DIR := build
SRCS := $(wildcard $(SRC_DIR)/*.java)
CLS := $(SRCS:$(SRC_DIR)/%.java=$(OUT_DIR)/%.class)
JC := javac
JCFLAGS := -d $(OUT_DIR)/ -cp $(SRC_DIR)/

.SUFFIXES: .java

.PHONY: all clean

all: $(CLS)

$(CLS): $(OUT_DIR)/%.class: $(SRC_DIR)/%.java
	$(JC) $(JCFLAGS) $<

clean:
	rm $(OUT_DIR)/*.class
