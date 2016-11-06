all: ram

ram:
	iverilog -o test_ram test_ram.v
	./test_ram
	gtkwave test.vcd

clean:
	rm *~ test.vcd test_bench *.log *.aux *.pdf *.vcd test_4_bit
