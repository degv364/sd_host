////////////////////////////////////////////////////////
// File: sd_host_tester
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "defines.v"

`timescale 1ns/10ps
//FIXME: Add correct ports
//FIXME: Set stimulus signals in initial block


module sd_host_tester(
		      output reg       CLK,
		      output reg       CLK_card,
		      output reg       RESET,
		      output reg [3:0] data_from_card
		      );

   initial begin
      CLK 	= 1'b1;
      CLK_card 	= 1'b1;
      RESET 	= 1'b1;
      #8 RESET 	= 1'b0;

   end

   always #(1) CLK  <= !CLK;
   always #(4) CLK_card <= !CLK_card;
   
endmodule
