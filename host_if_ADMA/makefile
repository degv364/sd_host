all: ram fifo dma

ram:
	iverilog -o test_ram.x test_ram.v
	./test_ram.x
	gtkwave test_ram.vcd

fifo:
	iverilog -o test_fifo.x test_fifo.v
	./test_fifo.x
	gtkwave test_fifo.vcd

fetch:
	iverilog -o test_fetch.x test_fetch.v
	./test_fetch.x
	gtkwave test_fetch.vcd

transfer:
	iverilog -o test_transfer.x test_transfer.v
	./test_transfer.x
	gtkwave test_transfer.vcd

dma:
	iverilog -o test_dma.x test_dma,v
	./test_dma.x
	gtkwave test_dma.vcd


clean:
	rm *~ test.vcd test_bench *.vcd test_4_bit *.x
