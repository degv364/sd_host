
module BUF(A, Y);
input A;
output Y;
assign #4.6 Y = A; //2*delay_not
endmodule

module NOT(A, Y);
input A;
output Y;
assign #2.3 Y =  ~A;
endmodule

module NAND(A, B, Y);
input A, B;
output Y;
assign #6.5 Y =  ~(A & B);
endmodule

module NOR(A, B, Y);
input A, B;
output Y;
assign #8.8 Y =  ~(A | B); //delay_nand+delay_not
endmodule


//delay latch_d 10.95
module DFF(C, D, Q);
input C, D;
output reg Q;
always @(posedge C)
	Q <= #21.9 D; //2*latch_delay
endmodule

module DFFSR(C, D, Q, S, R);
input C, D, S, R;
output reg Q;
always @(posedge C, posedge S, posedge R)
	if (S)
		Q <= 1'b1;
	else if (R)
		Q <= 1'b0;
	else
		Q <= #21.9 D; //2*latch_delay
endmodule

