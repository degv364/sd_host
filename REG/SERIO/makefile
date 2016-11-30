all:

registers: registers.v
	
	iverilog -o bien.exe gen_registers.v 

prueba:
	iverilog -o bien.exe regs.v prueba_reg.v test_registers.v

gtkwave:
	iverilog -o bien.exe gen_registers.v prueba_reg.v test_registers.v
	vvp bien.exe
	gtkwave test_registers.vcd
clean:
	rm *.exe *.vcd *~
