SHELL = /bin/bash

JAVA = /usr/bin/java
JAR = /usr/bin/jar
JAVAC = /usr/bin/javac

NAMESPACE = com.craftinginterpreters
NAMESPACE_PATH = com/craftinginterpreters
SRC_PATH = src/$(NAMESPACE_PATH)
BUILD_PATH = out
DIST_PATH = dist
CLASSPATH = $(BUILD_PATH)/production/lox

.PHONY: default
default: all

.PHONY: clean
clean:
	@echo ">>> cleaning"
	rm -rf $(BUILD_PATH)
	rm -rf $(DIST_PATH)

.PHONY: buildtools
buildtools: clean
	@echo ">>> building tools"
	mkdir -p $(CLASSPATH)
	javac -d $(CLASSPATH) $(SRC_PATH)/tool/*.java

.PHONY: ast
ast: buildtools
	echo ">>> building AST"
	$(JAVA) -classpath $(CLASSPATH) $(NAMESPACE).tool.GenerateAst $(SRC_PATH)/lox >/dev/null

.PHONY: build
build: buildtools ast
	echo ">>> building project"
	javac -d $(CLASSPATH) $(SRC_PATH)/lox/*.java

.PHONY: interpreter
interpreter: build
	$(JAVA) -classpath $(CLASSPATH) $(NAMESPACE).lox.Lox

.PHONY: dist
dist: build
	echo ">>> creating jar"
	mkdir $(DIST_PATH)
	cd $(CLASSPATH) && $(JAR) cfe jlox.jar $(NAMESPACE).lox.Lox $(NAMESPACE_PATH)/lox/*.class
	mv $(CLASSPATH)/jlox.jar $(DIST_PATH)


.PHONY: all
all: dist
