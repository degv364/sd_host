all:
	iverilog -o dsn CMD_master.v tb_cmd_master.v
	vvp dsn
clean:
	rm -f dsn test.vcd
