#este makefile es solo para pruebas del dma


dma_ram:
	iverilog -o test_ram.x test_ram.v -I ..
	./test_ram.x
	gtkwave test_ram.vcd

dma_fifo:
	iverilog -o test_fifo.x test_fifo.v -I ..
	./test_fifo.x
	gtkwave test_fifo.vcd

dma_fetch:
	iverilog -o test_fetch.x test_fetch.v -I ..
	./test_fetch.x
	gtkwave test_fetch.vcd gtks/fetch.gtkw &

dma_transfer:
	iverilog -o test_transfer.x test_transfer.v -I ..
	./test_transfer.x
	gtkwave test_transfer.vcd gtks/transfer.gtkw

dma_state_machine:
	iverilog -o test_state_machine.x test_state_machine.v -I ..
	./test_state_machine.x
	gtkwave test_state_machine.vcd

dma_dma:
	iverilog -o test_dma.x test_dma.v -I ..
	./test_dma.x
	gtkwave test_dma.vcd

dma_synth_fetch:
	yosys yosys/fetch.ys

dma_synth_transfer:
	yosys yosys/transfer.ys

dma_synth_state_machine:
	yosys yosys/state_machine.ys


dma_synth_dma:
	yosys yosys/dma.ys
clean:
	rm -rf *.x *.vcd
