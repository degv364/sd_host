module prueba_reg(
output [31:0] enb,
output [31:0] wr_data,
output clk,
output reset
);
reg [31:0] enb = 32'h0000_0000;
always # 1 enb = enb +1;

reg [31:0] wr_data = 32'hFFFF_FFFF;

reg clk = 0; 
always #5 clk = ~ clk;

reg reset = 1;

initial begin
	#  4 reset = 0;
	#1000 $finish;
end 
endmodule
