//Este archivo es la simulacion de una RAM.
//no es parte de la implementacion de SD host
//Pero es necesario para el testbench.
//Lee y escribe en la direccion determinada.

module ram(address,data_in, write, read, data_out, CLK);
   input [63:0] address;
   input [31:0] data_in;
   input 	write;
   input 	read;
   input 	CLK;
   
   
   
   output [31:0] data_out;
   reg [31:0] 	 data_out;
   

   reg [1024:0] info;
   wire [96:0] 	scope;
   
   //assign address_end= address+31;
   assign scope = info[608:512];
   
   
   //verify mod 32, valid address. whole words

   always @(posedge CLK) begin
      if (address[4:0]==0) begin
	 if (write==1) begin
	    info[address+:32]=data_in;
	 end
	 if (read==1) begin
	    data_out=info[address+:32];
	 end
      end
   end

endmodule // ram


	 
