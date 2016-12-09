////////////////////////////////////////////////////////
// Module: fetch
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////
`include "../../defines.v"


module fetch (input start,
	     input [63:0]  address,
	     output [95:0] address_descriptor,
	     input [31:0]  ram_data,
	     output [63:0] address_to_fetch,
	     output 	   address_fetch_done,
	     output start_confirmation,	   
	     input 	   CLK);

   parameter WAIT = 4'b0001;
   parameter FST_FETCH = 4'b0010;
   parameter SND_FETCH = 4'b0100;
   parameter TRD_FETCH = 4'b1000;

   reg [3:0] 		   state;
   reg [3:0] 		   next_state;
   reg [95:0] 		   address_descriptor;
   reg [63:0] 		   address_to_fetch;
   reg 			   address_fetch_done;
   reg 			   start_confirmation;
   

   //secuential part part
   always @(posedge CLK) begin
      state=next_state;
   end

   //next state logic
   always @(*) begin
      case (state)
	WAIT: begin
	   if (start==1) begin
	     next_state=FST_FETCH;
	   end
	   else begin
	      next_state=next_state;
	   end
	end
	FST_FETCH: begin
	   next_state=SND_FETCH;
	end
	SND_FETCH: begin
	   next_state=TRD_FETCH;
	end
	TRD_FETCH: begin
	   next_state=WAIT;
	end
	default: begin
	   next_state=WAIT;
	end
      endcase // case (state)
   end // always @ (*)

   //combinational part for outputs
   always @(*) begin
      case (state)
	WAIT: begin
	   address_fetch_done=1;
	   address_to_fetch = address;
	   address_descriptor = address_descriptor;
	   start_confirmation =0;
	   
	   
	end
	FST_FETCH: begin
	   address_fetch_done=0;
	   address_to_fetch = address+4;
	   address_descriptor[31:0]=ram_data;
	   start_confirmation=0;
	   
	   
	end
	SND_FETCH: begin
	   address_fetch_done=0;
	   address_to_fetch = address+8;
	   address_descriptor[63:32] = ram_data;
	   start_confirmation=1;
	   
	end
	TRD_FETCH: begin
	   address_fetch_done=1;
	   address_to_fetch = address;
	   address_descriptor[95:64] = ram_data;
	   start_confirmation=0;
	   
	end
	default: begin
	   address_fetch_done=1;
	   address_to_fetch = address;
	   address_descriptor = 0;
	   start_confirmation=0;
	   
	end
      endcase // case (state)
   end // always @ (*)
endmodule // fetch


      
   
   
