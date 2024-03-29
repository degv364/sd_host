#////////////////////////////////////////////////////////
#// File: Makefile
#// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
#// Project: SD Host Controller
#////////////////////////////////////////////////////////

#--------- Flags and variables ----------

CC := iverilog
SIM := vvp
VIEW := gtkwave

BINARY := sd_host_test
TEST_BENCH := SD_HOST/sd_host_tb.v

INC_DIRS := DAT/modules CMD SD_HOST buffer ADMA/modules
MOD_DIRS := DAT/modules CMD/modules ADMA/modules SD_HOST
SIM_DIR := sim

INC_PARAMS := $(foreach d, $(INC_DIRS), -I$d)
MODULES := $(foreach d, $(MOD_DIRS), $(wildcard $(d)/*.v))

FLAGS := $(INC_PARAMS) -Ttyp

ifneq ("$(RD)","1")
FLAGS += -D WRITE
endif

#-------------- Targets -----------------

all: run

run: $(BINARY).vcd
ifneq ("$(wildcard $(SIM_DIR)/$(BINARY).gtkw)","")
	$(VIEW) $(SIM_DIR)/$(BINARY).gtkw
else
	$(VIEW) $(SIM_DIR)/$(BINARY).vcd
endif

$(BINARY).vcd:
	$(CC) $(FLAGS) -o $(SIM_DIR)/$(BINARY).x $(TEST_BENCH) yosys_libs/cmos_cells.v
	$(SIM) $(SIM_DIR)/$(BINARY).x -l $(SIM_DIR)/$(BINARY).txt

clean:
	rm -f $(SIM_DIR)/*.x $(SIM_DIR)/*.vcd $(SIM_DIR)/*.txt 
