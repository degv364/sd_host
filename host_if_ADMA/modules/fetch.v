
module fetch(input start,
	     input [63:0]  address,
	     output [95:0] address_descriptor,
	     input [31:0]  ram_data,
	     output [63:0] address_to_fetch,
	     output address_fetch_done,
	     input 	   CLK);

   //TODO: Agregar estado de espera, para que ram responda
   parameter WAIT = 4'b0001;
   
   parameter FST_FETCH = 4'b0010;
   parameter SND_FETCH = 4'b0100;
   parameter TRD_FETCH = 4'b1000;

   reg [3:0] 		   state;
   reg [3:0] 		   next_state;

   reg [95:0] 		   address_descriptor;
   
   
   reg 			   internal_start;
   reg [63:0] 		   address_to_fetch;
   reg 			   address_fetch_done;
   
   

   always @(posedge CLK) begin
      if (start==0) begin
	 state=WAIT;
	 //next_state=FST_FETCH;
	 
      end
      else begin
	 state=next_state;
      end
   end

   always @(*) begin
      if (start==1) begin
	 //blah
	 case (state)
	   FST_FETCH: begin
	      //first fetch
	      next_state=SND_FETCH;
	      address_to_fetch = address;
	      address_descriptor[31:0]=ram_data;
	      address_fetch_done=0;
	      
	   end
	   SND_FETCH: begin
	      //second fetch
	      next_state=TRD_FETCH;
	      address_to_fetch = address+4;
	      address_descriptor[63:32] = ram_data;
	      address_fetch_done=0;
	      
	   end
	   TRD_FETCH: begin
	      //final fetch
	      next_state=WAIT;
	      address_to_fetch = address+8;
	      address_descriptor[95:64] = ram_data;
	      address_fetch_done=1;
	      
	   end

	   WAIT: begin
	      next_state=FST_FETCH;
	      address_to_fetch = address;
	      address_descriptor = 0;
	      address_fetch_done=0;
	      
	   end
	   
	   default: begin
	      //first fetch
	      next_state=SND_FETCH;
	      address_to_fetch = address;
	      address_descriptor[31:0]=ram_data;
	      address_fetch_done=0;
	   end
	 endcase // case (state)
	 
	      
      end // if (start==1)
      
      else begin
	 next_state=FST_FETCH;
	 address_fetch_done=1;
	 
      end // else: !if(start==1)
   end // always @ (*)
endmodule // fetch

   
      
