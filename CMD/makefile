all:
	iverilog -o simulations/dsn CMD_master.v tb_cmd_master.v
	iverilog -o simulations/dsn2 CMD_physical.v tb_parallel_to_serial.v
	iverilog -o simulations/dsn3 CMD_physical.v tb_serial_to_parallel.v
	iverilog -o simulations/dsn4 CMD_physical.v tb_cmd_physical.v
	iverilog -o simulations/dsn5 tb_CMD_TLB.v
	vvp simulations/dsn
	vvp simulations/dsn2
	vvp simulations/dsn3
	vvp simulations/dsn4
	vvp simulations/dsn5
clean:
	rm -f simulations/dsn simulations/dsn2 simulations/dsn3 simulations/dsn4 simulations/dsn5 simulations/*.vcd
