SHELL = /bin/bash

JAVA = /usr/bin/java
JAVAC = /usr/bin/javac
SRC_PATH = src/com/craftinginterpreters
CLASSPATH = out/production/lox
NAMESPACE = com.craftinginterpreters

.PHONY := default
default: all

.PHONY := clean
clean:
	@echo "cleaning"
	rm -rf $(CLASSPATH)

.PHONY := buildtools
buildtools: clean
	@echo "building tools"
	mkdir -p $(CLASSPATH)
	javac -d $(CLASSPATH) $(SRC_PATH)/tool/*.java

.PHONY := build
build: buildtools
	@echo "building lox"
	javac -d $(CLASSPATH) $(SRC_PATH)/lox/*.java

.PHONY := ast
ast: buildtools
	@echo building AST classes
	$(JAVA) -classpath $(CLASSPATH) $(NAMESPACE).tool.GenerateAst $(SRC_PATH)/lox

.PHONY := lox
lox: ast build
	$(JAVA) -classpath $(CLASSPATH) $(NAMESPACE).lox.Lox


.PHONY := all
all: lox
