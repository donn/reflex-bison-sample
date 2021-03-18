# Detect Tools
BISON ?= bison
CC ?= cc
CXX ?= c++

# Detect Terminal Color Support
COLORS = $(shell tput colors || echo 0)
ifeq ($(COLORS),256)
    PRESET = \033[1;32m
    RESET = \033[0m
endif

BUILD_DIR = build

# Compiling RE-flex
REFLEX_DIR = re-flex
REFLEX_UNICODE_SRC_DIR = $(REFLEX_DIR)/unicode
REFLEX_LIB_SRC_DIR = $(REFLEX_DIR)/lib
REFLEX_LIB_HEADER_DIR = $(REFLEX_DIR)/include

REFLEX_LIB_SOURCES = $(shell find $(REFLEX_LIB_SRC_DIR) | grep .cpp)
REFLEX_UNICODE_SOURCES = $(shell find $(REFLEX_UNICODE_SRC_DIR) | grep .cpp)

REFLEX_LIB_OBJECTS = $(addprefix $(BUILD_DIR)/, $(patsubst %.cpp,%.o,$(REFLEX_LIB_SOURCES)))
REFLEX_UNICODE_OBJECTS =  $(addprefix $(BUILD_DIR)/, $(patsubst %.cpp,%.o,$(REFLEX_UNICODE_SOURCES)))

REFLEX_ALL = $(REFLEX_DIR)/src/reflex.cpp $(REFLEX_LIB_OBJECTS) $(REFLEX_UNICODE_OBJECTS)

# Scanner and Parser Generation
YACC_FLAGS = --verbose

LEX = tokens.l
YACC = grammar.yy
LEX_OUT = $(addprefix $(BUILD_DIR)/, $(patsubst %,%.cc,$(LEX)))
LEX_HEADER = $(addprefix $(BUILD_DIR)/, $(patsubst %,%.hh,$(LEX)))
YACC_OUT = $(addprefix $(BUILD_DIR)/, $(patsubst %,%.cc,$(YACC)))

# Compilation
CPP_LY_FLAGS = -std=c++17 -I./re-flex/include
CPP_FLAGS = -Wall -pedantic -Ibuild/ -I./re-flex/include

CPP_LY_SOURCES = $(YACC_OUT) $(LEX_OUT)
CPP_SOURCES = main.cc
CPP_HEADERS = 

CPP_LY_OBJECTS = $(patsubst %.cc,%.o,$(CPP_LY_SOURCES))
CPP_OBJECTS = $(addprefix $(BUILD_DIR)/, $(patsubst %.cc,%.o,$(CPP_SOURCES)))

# Target
BINARY = parser

all: CPP_FLAGS += -g -DYYDEBUG=1
all: CPP_LY_FLAGS += -g -DYYDEBUG=1
all: C_FLAGS += -g
all: $(BINARY)

$(YACC_OUT): $(YACC)
	mkdir -p $(@D)
	@echo "$(PRESET)>> Generating parser... $(RESET)"
	$(BISON) $(YACC_FLAGS) -o $@ -d $^

$(REFLEX_LIB_OBJECTS): $(BUILD_DIR)/%.o : %.cpp $(REFLEX_LIB_HEADER_DIR)
	mkdir -p $(@D)
	@echo "$(PRESET)>> Compiling $< $(RESET)"
	$(CXX) $(CPP_LY_FLAGS) -c -I$(REFLEX_LIB_HEADER_DIR) -o $@ $<

$(REFLEX_UNICODE_OBJECTS): $(BUILD_DIR)/%.o : %.cpp $(REFLEX_LIB_HEADER_DIR)
	mkdir -p $(@D)
	@echo "$(PRESET)>> Compiling $< $(RESET)"
	$(CXX) $(CPP_LY_FLAGS) -c -I$(REFLEX_LIB_HEADER_DIR) -o $@ $<

build/reflex: $(REFLEX_ALL)
	mkdir -p $(@D)
	@echo "$(PRESET)>> Compiling and linking the RE-flex binary $(RESET)"
	$(CXX) $(CPP_LY_FLAGS) -I $(REFLEX_LIB_HEADER_DIR) -o $@ $^

$(LEX_OUT): $(LEX) $(YACC_OUT) build/reflex
	mkdir -p $(@D)
	@echo "$(PRESET)>> Generating scanner... $(RESET)"
	build/reflex -o $@ --header-file=$(LEX_HEADER) $<

$(LEX_HEADER): $(LEX_OUT)
	@echo "$(PRESET)>> Scanner header generated.$(RESET)"

$(CPP_LY_OBJECTS): %.o : %.cc $(YACC_OUT) $(LEX_OUT) $(CPP_HEADERS) $(HEADERS)
	mkdir -p $(@D)
	@echo "$(PRESET)>> Compiling $< $(RESET)"
	$(CXX) $(CPP_LY_FLAGS) -I$(BUILD_DIR) -I/usr/local/include/ -c -o $@ $<

$(CPP_OBJECTS): $(BUILD_DIR)/%.o : %.cc $(YACC_OUT) $(LEX_OUT) $(CPP_HEADERS) $(HEADERS)
	mkdir -p $(@D)
	@echo "$(PRESET)>> Compiling $< $(RESET)"
	$(CXX) $(CPP_FLAGS) -c -o $@ $<

$(BINARY): $(CPP_OBJECTS) $(CPP_LY_OBJECTS) $(REFLEX_LIB_OBJECTS) $(REFLEX_UNICODE_OBJECTS)
	mkdir -p $(@D)
	@echo "$(PRESET)>> Linking $(BINARY) $(RESET)"
	$(CXX) -o $@ $^ $(LD_FLAGS)
	@echo "$(PRESET)>> Build complete.$(RESET)"

.PHONY: clean

clean:
	rm -rf $(BUILD_DIR)
	rm parser