////////////////////////////////////////////////////////
// Module: dual_ff_sync (Dual Flip-Flop CDC Synchronizer)
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`timescale 1ns/10ps

module dual_ff_sync(input out_clk,
		    input rst_L,
		    input in_data,
		    output out_data
		    );

   reg [1:0] 		   dual_ff;

   assign out_data = dual_ff[1];

   always @(posedge out_clk or !rst_L) begin
      if(!rst_L) begin
	 dual_ff <= 0;
      end
      else begin
	 dual_ff <= {dual_ff[0], in_data};
      end
   end

endmodule
