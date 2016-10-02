
module BUF(A, Y);
   input A;
   output Y;
   assign Y = A;
   integer count=0;
   always @(Y) begin
      count=count+1;
   end
endmodule

module NOT(A, Y);
   input A;
   output Y;
   assign Y = ~A;
   integer count=0;
   always @(Y) begin
      count=count+1;
   end
endmodule

module NAND(A, B, Y);
   input A, B;
   output Y;
   assign Y = ~(A & B);
   integer count=0;
   always @(Y) begin
      count=count+1;
   end
endmodule

module NOR(A, B, Y);
   input A, B;
   output Y;
   assign Y = ~(A | B);
   integer count=0;
   always @(Y) begin
      count=count+2; //en general 2, por estar compuesto por inversores y nands
   end
endmodule

module DFF(C, D, Q);
   input C, D;
   output reg Q;
   always @(posedge C)
     Q <= D;
   integer count=0;
   always @(Q) begin
      count=count+1;
   end
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
       Q <= D;
   integer count=0;
   always @(Q) begin
      count=count+1;
   end
endmodule

