
#Flags and variables
CC := iverilog
SIM := vvp
VIEW := gtkwave

BINARY := dat_test
TEST_BENCH := dat_tb.v

SRC_DIR := modules
GTKW_DIR := gtkw

FLAGS := -I$(SRC_DIR) -Ttyp

#Targets
run: $(BINARY).vcd
ifneq ("$(wildcard $(GTKW_DIR)/$(BINARY).gtkw)","")
	$(VIEW) $(GTKW_DIR)/$(BINARY).gtkw
else
	$(VIEW) $(BINARY).vcd
endif

$(BINARY).o: $(SRC_DIR)/*
	$(CC) $(FLAGS) -o $@ $(SRC_DIR)/$(TEST_BENCH)

$(BINARY).vcd: $(BINARY).o
	$(SIM) $< -l $(BINARY).txt
clean:
	rm -f *.o *.vcd *.txt 
