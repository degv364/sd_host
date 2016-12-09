////////////////////////////////////////////////////////
// Module: transfer
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////
`include "defines.v"


//Modulo que realiza la transferencia de datos
//FIXME: timeout termination
//FIXME: Length indicates cant of bytes 	       
module transfer(input start,
		input 	      direction,
		output 	      TFC,
		input [63:0]  address_init,
		input [15:0]  length,
		output 	      ram_read,
		output 	      ram_write,
		output 	      fifo_read,
		output 	      fifo_write,
		input [31:0]  data_from_ram,
		output [31:0] data_to_ram,
		input [31:0]  data_from_fifo,
		output [31:0] data_to_fifo,
		output [63:0] ram_address,
		input 	      fifo_empty,
		input 	      fifo_full,
		input 	      CLK
		);
   wire 		      CLK; //just to make this module aware of clk
   reg 			      not_half_clk;
   reg 			      half_clk;
   // always @(posedge CLK)begin
   //    if (start==1)begin
   // 	 half_clk=start;
   //    end
   //    else begin
   // 	 half_clk+=1;
   //    end
   // end
   
   
   
   

   parameter IDLE=      5'b00001;
   parameter FIFO_RAM=  5'b00010;
   parameter RAM_FIFO=  5'b00100;
   parameter WAIT_READ= 5'b01000;
   parameter WAIT_WRITE=5'b10000;
   

   reg 		       TFC;
   reg 		       ram_read;
   reg 		       ram_write;
   reg 		       fifo_read;
   reg 		       fifo_write;
   reg 		       data_to_ram;
   reg 		       data_to_fifo;
   reg [63:0] 	       ram_address;


   reg [4:0] 	       state;
   reg [4:0] 	       next_state;


   ///internal variables for sum
   wire [63:0] 	       length_64;
   wire [63:0] 	       sum_result;
   
   assign length_64=length<<0;//<<2; //length in bits, not in bytes
   assign sum_result=address_init+length_64;
   

   //secuential part
   always @(posedge CLK) begin
      state=next_state;   
   end

   //next state logic

   always @(*) begin
      case (state)
	IDLE: begin
	   if (start==1) begin
	      if (direction==0)begin
		 next_state=FIFO_RAM;
	      end
	      else begin
		 next_state=RAM_FIFO;
	      end
	   end
	   else begin
	      next_state=next_state;
	   end // else: !if(start==1)   
	end // case: IDLE
	
	FIFO_RAM: begin
	   if (TFC==1) begin
	      next_state=IDLE;
	   end
	   else begin
	      if (fifo_empty==1) begin
		 next_state=WAIT_READ;
	      end
	      else begin
		 next_state=FIFO_RAM;
	      end
	   end // else: !if(TFC==1)
	end // case: FIFO_RAM
	
	RAM_FIFO: begin
	   if (TFC==1) begin
	      next_state=IDLE;
	   end
	   else begin
	      if (fifo_full==1) begin
		 next_state=WAIT_WRITE;
	      end
	      else begin
		 next_state=RAM_FIFO;
	      end
	   end // else: !if(TFC==1)
	end // case: RAM_FIFO
	
	WAIT_READ: begin
	   if (fifo_empty==1)begin
	      next_state=WAIT_READ;
	   end
	   else begin
	      next_state=FIFO_RAM;
	   end
	end
	
	WAIT_WRITE: begin
	   if (fifo_full==1) begin
	      next_state=WAIT_WRITE;
	   end
	   else begin
	      next_state=RAM_FIFO;
	   end
	end
	
	default: begin
	   next_state=IDLE;
	end
      endcase // case (state)
   end // always @ (*)
   
   //logic for outputs

   always @(*) begin
      not_half_clk=!half_clk; //just to include CLK as update signal here
      
      case (state)
	IDLE: begin
	   ram_read=1;
	   ram_write=0;
	   fifo_read=0;
	   fifo_write=0;
	   data_to_ram=0;
	   data_to_fifo=0;
	   ram_address=address_init;
	   TFC=1; //TODO: check if this is necesary 
	end
	FIFO_RAM: begin
	   ram_read=0;
	   ram_write=1;
	   fifo_read=1;
	   fifo_write=0;
	   data_to_fifo=0;
	   data_to_ram=data_from_fifo;
	   if (ram_address==sum_result) begin
	      //transfer is complete
	      TFC=1;
	   end
	   else begin
	      TFC=0;
	   end
	   ram_address=ram_address+4; //TODO: this may not be the correct order, see when to update address
	end // case: FIFO_RAM
	
	RAM_FIFO: begin
	   ram_read=1;
	   ram_write=0;
	   fifo_read=0;
	   fifo_write=1;
	   data_to_fifo=data_from_ram;
	   data_to_ram=0;
	   if (fifo_full==1)begin
	      ram_address=ram_address;
	      fifo_write=0;
	   end
	   else begin
	      fifo_write=1;
	      ram_address=ram_address+4; //TODO: this may not be the correct order, see when to update address
	   end
	   
	   if (ram_address==sum_result) begin
	      //transfer is complete
	      TFC=1;
	   end
	   else begin
	      TFC=0;
	   end
	end // case: RAM_FIFO
	
	WAIT_READ: begin
	   ram_read=0;
	   ram_write=0;
	   fifo_read=0;
	   fifo_write=0;
	   data_to_fifo=0;
	   data_to_ram=data_to_ram;
	   ram_address=ram_address;
	   TFC=0;
	   
	   
       	end
	
	WAIT_WRITE: begin
	   ram_read=0;
	   ram_write=0;
	   fifo_read=0;
	   fifo_write=0;
	   data_to_fifo=data_to_fifo;
	   data_to_ram=0;
	   ram_address=ram_address;
	   TFC=0;
	   if (fifo_full==0) begin
	      fifo_write=1;   
	   end
	   
	   
	   
	end
	
	default: begin
	   ram_read=0;
	   ram_write=0;
	   fifo_read=0;
	   fifo_write=0;
	   data_to_ram=0;
	   data_to_fifo=0;
	   ram_address=address_init;
	   TFC=1;
	end
      endcase // case (state)
   end // always @ (*)

   always @(posedge CLK)begin
      if (state==IDLE)begin
	 half_clk=start;
      end
      else begin
	 half_clk+=1;
      end
   end
      
endmodule // transfer

	  
