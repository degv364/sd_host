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
		      output reg [3:0] data_from_card,
		      output  [11:0]reg_address,
		      output  [31:0]reg_wr_data,
		      output       reg_wr_en
		      
		       
		      );

	reg [11:0] reg_address = 0;
	reg [31:0] reg_wr_data = 0;
	reg reg_wr_en = 1;
	


   initial begin
      CLK 	= 1'b1;
      CLK_card 	= 1'b1;
      RESET 	= 1'b1;
      
      //CMD
      #2 reg_address = 12'h008;
      reg_wr_data = 32'h0000_0123;
      #2 reg_address = 12'h00A;
      reg_wr_data = 32'h0000_4567;
      #2 reg_address = 12'h00E; //aqui empieza a funcionar el sd_host pues start_flag se activa
      reg_wr_data = 32'b0000_0000_0000_0000_0001_1001_0011_0011;
      
      
      
      
      #8 RESET 	= 1'b0;
      

   end

   always #(1) CLK  <= !CLK;
   always #(4) CLK_card <= !CLK_card;
   
endmodule
