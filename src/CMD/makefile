all: cmd individual

individual:
	iverilog -o simulations/dsn.x modules/CMD_master.v modules/tb_cmd_master.v
	iverilog -o simulations/dsn4.x modules/CMD_physical.v modules/tb_cmd_physical.v
	vvp simulations/dsn.x
	vvp simulations/dsn4.x
	
cmd:
	iverilog -o simulations/dsn5.x modules/tb_CMD.v
	vvp simulations/dsn5.x
	
	
synth:
	yosys yosys/cmd.ys
	
clean:
	rm -f simulations/*.x simulations/*.vcd yosys/synth_CMD.v
