//Este archivo es la simulacion de una RAM.
//no es parte de la implementacion de SD host
//Pero es necesario para el testbench.
//Lee y escribe en la direccion determinada.

module ram(input [63:0] address,
	   input [31:0] data_in, 
	   input write, 
	   input read, 
	   output [31:0] data_out, 
	   input CLK
	   );
   
   reg [31:0] 	 data_out;

   wire [63:0] 	 address_bits;
   assign address_bits= address<<3;
   
   reg [1024:0] info=0;

   always @(posedge CLK) begin
      //if (address[4:0]==0) begin
      if (address[1:0]==0)begin
	 if (write==1) begin
	    info[address_bits+:31]=data_in;
	 end
	 if (read==1) begin
	    data_out=info[address_bits+:31];
	 end
      end
   end

   //Escritura de constantes en ram
   always @(CLK) begin
      info [31:0]=1;
      info [63:32]=2;
      info [95:64]=3;
      info [127:96]=4;
      info [159:128]=5;
      
   end

   wire [63:0] scope_00;
   wire [63:0] scope_01;
   wire [63:0] scope_02;
   wire [63:0] scope_03;
   wire [63:0] scope_04;
   wire [63:0] scope_05;
   wire [63:0] scope_06;
   wire [63:0] scope_07;
   wire [63:0] scope_08;
   wire [63:0] scope_09;
   wire [63:0] scope_10;
   wire [63:0] scope_11;
   wire [63:0] scope_12;
   wire [63:0] scope_13;
   wire [63:0] scope_14;
   wire [63:0] scope_15;
			
   
   assign scope_00=info[63:0];
   assign scope_01=info[127:64];
   assign scope_02=info[191:128];
   assign scope_03=info[255:192];
   assign scope_04=info[319:256];
   assign scope_05=info[383:320];
   assign scope_06=info[447:384];
   assign scope_07=info[511:448];
   assign scope_08=info[575:512];
   assign scope_09=info[639:576];
   assign scope_10=info[703:640];
   assign scope_11=info[767:704];
   assign scope_12=info[831:768];
   assign scope_13=info[895:832];
   assign scope_14=info[959:896];
   assign scope_15=info[1023:960];
   
endmodule // ram


	 
