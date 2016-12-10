synth:
	yosys synth_com.ys
	yosys synth_regs.ys

regs:
	iverilog -o registros.x reg_sintetizado.v probador_regs.v test_registers.v cmos_cells.v
	vvp registros.x
	gtkwave test_registers.vcd

##communication:
##	iverilog -o communication.x com_sintetizado.v ##probador_cpu.v test_cpu_transfer.v cmos_cells.v
#	vvp communication.x
#	gtkwave test_cpu_transfer.vcd

clean:
	rm *.vcd *~ *.x
