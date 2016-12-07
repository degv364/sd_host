module test_registers();
initial begin
	$dumpfile("test_registers.vcd");
	$dumpvars(0,test_registers);
end
	wire clk,reset;
	wire [31:0] enb; 
	wire [31:0] wr_data;
	prueba_reg	reg_p(.clk(clk),.reset(reset),.wr_data(wr_data),.enb(enb));
	reg_32	reg_1(.clk(clk),.reset(reset),.wr_data(wr_data),.enb(enb));

endmodule


