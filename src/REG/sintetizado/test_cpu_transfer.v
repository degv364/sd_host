module test_cpu_transfer();
initial begin
	$dumpfile("test_cpu_transfer.vcd");
	$dumpvars();
end
	wire clk,reset,req;
	wire [31:0] enb; 
	wire [31:0] wr_data;
	wire [31:0] out_004h;
	wire [11:0] addrs;

	cpu_reg_communication	communication_block(.in_004h(out_004h),.addrs(addrs),.wr_valid(enb),.req(req));
	probador_cpu		communication_prove(.out_004h(out_004h),.addrs(addrs),.wr_valid(enb),.req(req));

endmodule


