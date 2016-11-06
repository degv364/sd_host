all: ram fifo

ram:
	iverilog -o test_ram.x test_ram.v
	./test_ram.x
	gtkwave test_ram.vcd

fifo:
	iverilog -o test_fifo.x test_fifo.v
	./test_fifo.x
	gtkwave test_fifo.vcd


clean:
	rm *~ test.vcd test_bench *.log *.aux *.pdf *.vcd test_4_bit *.x
