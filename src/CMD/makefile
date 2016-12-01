all: individual_tb cmd

individual:
	iverilog -o simulations/dsn.x CMD_master.v tb_cmd_master.v
	iverilog -o simulations/dsn2.x CMD_physical.v tb_parallel_to_serial.v
	iverilog -o simulations/dsn3.x CMD_physical.v tb_serial_to_parallel.v
	iverilog -o simulations/dsn4.x CMD_physical.v tb_cmd_physical.v
	vvp simulations/dsn.x
	vvp simulations/dsn2.x
	vvp simulations/dsn3.x
	vvp simulations/dsn4.x
	
cmd:
	iverilog -o simulations/dsn5.x tb_CMD.v
	vvp simulations/dsn5.x
	
clean:
	rm -f simulations/*.x simulations/*.vcd
