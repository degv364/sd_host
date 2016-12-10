regs:
	iverilog -o registros.x regs.v probador_regs.v test_registers.v
	vvp registros.x
	gtkwave test_registers.vcd

communication:
	iverilog -o communication.x cpu_communication.v probador_cpu.v test_cpu_transfer.v 
	vvp communication.x
	gtkwave test_cpu_transfer.vcd

clean:
	rm *.vcd *~ *.x
