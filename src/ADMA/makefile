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
	gtkwave test_fetch.vcd gtks/fetch.gtkw &

transfer:
	iverilog -o test_transfer.x test_transfer.v
	./test_transfer.x
	gtkwave test_transfer.vcd gtks/transfer.gtkw

state_machine:
	iverilog -o test_state_machine.x test_state_machine.v
	./test_state_machine.x
	gtkwave test_state_machine.vcd

synth_fetch:
	yosys yosys/fetch.ys

synth_transfer:
	yosys yosys/transfer.ys


clean:
	rm  *.vcd *.x
