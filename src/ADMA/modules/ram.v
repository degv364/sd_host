////////////////////////////////////////////////////////
// Module: ram.v
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////


//Este archivo es la simulacion de una RAM.
//no es parte de la implementacion de SD host
//Pero es necesario para el testbench.
//Lee y escribe en la direccion determinada.

`include "defines.v"

//`define GENERAL
//`define DMA

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
   
   reg [1023:0] info=0;

   always @(posedge CLK) begin
      //if (address[4:0]==0) begin
      if (address[1:0]==0)begin
	 if (write==1) begin
	    info[address_bits+:32]=data_in;
	 end
	 if (read==1) begin
	    data_out=info[address_bits+:32];
	 end
      end
   end

`ifdef GENERAL
   
   //Escritura de constantes en ram
   always @(CLK) begin
      info [31:0]=1;
      info [63:32]=2;
      info [95:64]=3;
      info [127:96]=4;
      info [159:128]=5;
      
   end
`endif //  `ifdef GENERAL

`ifdef DMA
   always @(CLK) begin
      //first address descriptor
      info [95:32]=0; //initial address (to read)
      info [31:16]=5; //length
      info [15:6]=0;
      info [5:0]=6'b010001;//tran, valid.
      //second address descriptor
      info [191:128]=64; //initial address (to write)
      info [127:112]=5; //length
      info [111:102]=0;
      info [101:96]=6'b010001;//tran, valid.
      //third address descriptor
      info [287:224]=0; //address to link
      info [223:208]=0;
      info [207:198]=0;
      info [197:192]=6'b110001; //link, valid
   end // always @ (CLK)
   

`endif
   
`ifdef SD_HOST_COMPLETE
   //first address descriptor
     integer i = 0;
     initial begin
     	info [95:32]=24; //initial address (to read)
     	info [31:16]=80; //length
     	info [15:6]=0;
     	info [5:0]=6'b010001;//tran, valid.
     	for(i=127; i<1023; i = i + 32) begin
   	   info [i-:32] = 0;// i*52427+3435973836;
   		
   	end
	info [191:128]=0;
	info [127:112]=0;
	info [111:102]=0;
	info [101:96]=6'b000010;//end comunication
	
     end
   	  
   
`endif   
   
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


	 
