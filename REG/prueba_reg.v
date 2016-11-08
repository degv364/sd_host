module prueba_reg(clk,reset,w)

output clk,enb;
parameter w = 8;

reg clk = 0;
always #5 clk = !clk;

reg reset = 1;

endmodule
