all:

registers: registers.v
	
	iverilog -o bien.exe registers.v 

prueba:
	iverilog -o bien.exe registers.v probador.v test_registers.v

gtkwave:
	iverilog -o bien.exe registers.v probador.v test_registers.v
	vvp test_registers.v
	gtkwave test_registers.vcd
clean:
	rm *.exe *.vcd *~
