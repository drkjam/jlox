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

.PHONY := build
build: clean
	@echo "building"
	mkdir -p $(CLASSPATH)
	javac -d $(CLASSPATH) $(SRC_PATH)/lox/*.java
	javac -d $(CLASSPATH) $(SRC_PATH)/tool/*.java

.PHONY := lox
lox:
	$(JAVA) -classpath $(CLASSPATH) $(NAMESPACE).lox.Lox


.PHONY := ast
ast: build
	@echo building AST classes
	$(JAVA) -classpath $(CLASSPATH) $(NAMESPACE).tool.GenerateAst $(SRC_PATH)/lox

.PHONY := all
all: ast
