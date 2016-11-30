module prueba_reg(clk,reset,wr_valid,wr_data);

output clk,reset,wr_valid;
output [31:0] wr_data;

reg clk = 0;
always #5 clk = !clk;

reg reset = 1;
 
	initial begin
	#10 reset = 0;
	end

reg wr_data = 32'hFFFE;
always #5 wr_data = wr_data + 1;

reg wr_valid = 0;
always #7 wr_valid = !wr_valid;

initial begin
	#500 $finish;
end

endmodule
