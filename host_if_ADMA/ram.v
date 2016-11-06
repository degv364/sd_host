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
   wire [7:0] 	scope;
   
   //assign address_end= address+31;
   assign scope = info[520:512];
   
   
   //verify mod 32, valid address. whole words
   always @(posedge CLK) begin
      if (address[4:0]==0) begin
	 //read or write
	 if (write==1) begin
	    //write
	    info[address+:32]=data_in;
	    
	 end else begin
	    if (read==1) begin
	       //read
	       data_out=info[address+:32];
	    end else begin
	       data_out=data_out;
	    end
	    
	 end // else: !if(write==1)
	 
      end else begin
	 //do nothing
	 data_out=data_out;
	 
      end // else: !if(address[4:0]==0)
      
   end // always @ (posedge CLK)
   

endmodule // ram


	 
