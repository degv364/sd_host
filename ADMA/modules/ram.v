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
   wire [11:0] 	scope;

   initial begin
      # 0 info=0;
   end
   
   
   //assign address_end= address+31;
   assign scope = info[75:64];
   
   
   //verify mod 32, valid address. whole words

   always @(posedge CLK) begin
      //if (address[4:0]==0) begin
      if (address[1:0]==0)begin
	 if (write==1) begin
	    info[address+:32]=data_in;
	 end
	 if (read==1) begin
	    data_out=info[address+:32];
	 end
      end
   end

   //Escritura de constantes en ram
   always @(CLK) begin
      info [67:64]=2;
      
      info[71:68]= 1;
      info[75:72]=1;
      
   end
   
   

endmodule // ram


	 
