`include "reg_n.v"
module sd_regs();
wire salida;
genvar i;
generate
for (i = 0; i < 64 ; i = i + 1) begin
	reg_n registro();
    end
endgenerate
//registro(1);


endmodule

