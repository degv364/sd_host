#////////////////////////////////////////////////////////
#// File: makefile
#// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio,
#// Daniel Piedra Perez, Esteban Zamora Alvarado
#// Project: SD Host Controller
#////////////////////////////////////////////////////////

#--------- Flags and variables ----------

CC := iverilog
SIM := vvp
VIEW := gtkwave

BINARY := sd_host_test
TEST_BENCH := sd_host_tb.v

INC_DIRS := DAT/modules CMD
MOD_DIRS := DAT/modules CMD/modules ADMA/modules
GTKW_DIR := gtkw

INC_PARAMS := $(foreach d, $(INC_DIRS), -I$d)
MODULES := $(foreach d, $(MOD_DIRS), $(wildcard $(d)/*.v))

FLAGS := $(INC_PARAMS) -Ttyp

#-------------- Targets -----------------

all: run

run: $(BINARY).vcd
ifneq ("$(wildcard $(GTKW_DIR)/$(BINARY).gtkw)","")
	$(VIEW) $(GTKW_DIR)/$(BINARY).gtkw
else
	$(VIEW) $(BINARY).vcd
endif

$(BINARY).o: $(MODULES)
	$(CC) $(FLAGS) -o $@ $(TEST_BENCH)

$(BINARY).vcd: $(BINARY).o
	$(SIM) $< -l $(BINARY).txt

clean:
	rm -f *.o *.vcd *.txt 
