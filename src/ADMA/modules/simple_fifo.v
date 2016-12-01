////////////////////////////////////////////////////////
// Module: simple_fifo
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "defines.v"

//simple fifo
//este modulo esta hacho para comunicarse con el DMA durante pruebas internas
//se puede leer o escribir, y tiene banderas para lleno y vacio.

module simple_fifo(input [31:0]  data_in,
		   output [31:0] data_out,
		   input  write,
		   input read,
		   output full,
		   output empty,
		   input CLK
		   );
   wire [31:0] 		  data_in;
   wire 		  write;
   wire 		  read;
   
   reg 			  full;
   reg 			  empty;
   reg [31:0] 		  data_out;


   reg [4:0] 		  read_address=0;
   reg [4:0] 		  write_address=0;

   wire [9:0] 		  rd_addr;
   wire [9:0] 		  wr_addr;
   
   assign rd_addr=read_address<<5;
   assign wr_addr=write_address<<5;
   

   reg [1023:0] 	  info;


   //update full/empy flags
   always @(*) begin
      if (read_address==write_address) begin
	 empty=1;
      end else begin
	 empty =0;
      end
      if (read_address==(write_address+1)) begin
	 full =1;
      end else begin
	 full =0;
      end
   end // always @ (*)

   //read or write    
   always @(posedge CLK) begin
      if (read==1) begin
	 //read
	 data_out=info[rd_addr+:32];
	 if (empty==0) begin
	    read_address=read_address+1;
	 end
	 else begin
	    read_address=read_address;
	 end
      end else begin
	 data_out=data_out;
	 read_address=read_address;
      end // else: !if(read==1)
      

      if (write==1) begin
	 info[wr_addr+:32]=data_in;
	 if (full==0) begin
	    write_address=write_address+1;
	 end
	 else begin
	    write_address=write_address;
	 end
      end
      
      else begin
	 write_address=write_address;
      end // else: !if(write==1)    
	 
   end // always @ (posedge CLK)
   
endmodule // simple_fifo

	 
     
      
	 
	    
	 
	    
		   
