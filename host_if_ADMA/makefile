all: ram fifo dma

ram:
	iverilog -o test_ram.x test_ram.v
	./test_ram.x
	gtkwave test_ram.vcd

fifo:
	iverilog -o test_fifo.x test_fifo.v
	./test_fifo.x
	gtkwave test_fifo.vcd

dma:
	iverilog -o test_dma.x test_dma,v
	./test_dma.x
	gtkwave test_dma.vcd


clean:
	rm *~ test.vcd test_bench *.log *.aux *.pdf *.vcd test_4_bit *.x
