module probador_cpu (
output [31:0] out_004h,
output [11:0] addrs,
output req,
output [31:0] wr_valid
);
reg out_004h = 32'h0000_0100;
always #15 out_004h <= out_004h+1;

reg clk = 0;
always #5 clk = !clk;

reg req = 0;
	initial begin
		#30 req = 1;
		#1000 $finish;
	end

reg addrs = 11'h004;

reg wr_valid = 1;
	initial begin
	#35 wr_valid = 0; 
	end
endmodule

