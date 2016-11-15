module test_registers();
initial begin
	$dumpfile("test_registers.vcd");
	$dumpvars(0,test_registers);
end
	wire clk,reset,wr_valid;
	wire [31:0] wr_data;
	prueba_reg	reg_p(.clk(clk),.reset(reset),.wr_data(wr_data),.wr_valid(wr_valid));
	reg_SDMA	reg_1(.clk(clk),.reset(reset),.wr_data(wr_data),.wr_valid(wr_valid));

endmodule


