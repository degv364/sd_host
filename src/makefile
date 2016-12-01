all: dma_dma

all_dma: dma_ram dma_fifo dma_fetch dma_transfer dma_state_machine dma_dma

dma_ram:
	iverilog -o ADMA/test_ram.x ADMA/test_ram.v
	ADMA/./test_ram.x
	gtkwave ADMA/test_ram.vcd

dma_fifo:
	iverilog -o ADMA/test_fifo.x ADMA/test_fifo.v
	ADMA/./test_fifo.x
	gtkwave ADMA/test_fifo.vcd

dma_fetch:
	iverilog -o ADMA/test_fetch.x ADMA/test_fetch.v
	ADMA/./test_fetch.x
	gtkwave ADMA/test_fetch.vcd ADMA/gtks/fetch.gtkw &

dma_transfer:
	iverilog -o ADMA/test_transfer.x ADMA/test_transfer.v
	ADMA/./test_transfer.x
	gtkwave ADMA/test_transfer.vcd ADMA/gtks/transfer.gtkw

dma_state_machine:
	iverilog -o ADMA/test_state_machine.x ADMA/test_state_machine.v
	ADMA/./test_state_machine.x
	gtkwave ADMA/test_state_machine.vcd

dma_dma:
	iverilog -o ADMA/test_dma.x ADMA/test_dma.v
	ADMA/./test_dma.x
	gtkwave ADMA/test_dma.vcd

dma_synth_fetch:
	yosys ADMA/yosys/fetch.ys

dma_synth_transfer:
	yosys ADMA/yosys/transfer.ys


clean:
	rm  ADMA/*.vcd ADMA/*.x
