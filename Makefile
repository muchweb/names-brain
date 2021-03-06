SOURCES := $(wildcard src/*.coffee)
LIBS1   := $(SOURCES:.coffee=.js)
LIBS    := $(subst src,lib,$(LIBS1))
COFFEE  := ./node_modules/.bin/coffee

all: $(LIBS)

$(LIBS): $(COFFEE) $(SOURCES)
	$(COFFEE) --map --compile --output lib src

$(COFFEE):
	npm install

clean:
	rm -r lib
	rm -r node_modules
