////////////////////////////////////////////////////////
// File: sd_host_tester
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio,
// Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "defines.v"

`timescale 1ns/10ps
//FIXME: Add correct ports
//FIXME: Set stimulus signals in initial block


module sd_host_tester(
		      output reg       host_clk,
		      output reg       sd_clk,
		      output reg       rst_L,
		      output reg [3:0] DAT_din,
		      );

   initial begin
      
   end

   always #(1) host_clk  = !host_clk;
   always #(4) sd_clk = !sd_clk;
   
endmodule
