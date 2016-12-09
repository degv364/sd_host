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
		      output  [31:0]reg_address,
		      output  [31:0]reg_wr_data,
		      output        reg_wr_en,
		      output	    req,
		      output        cmd_from_sd
	      
		      );

	reg [31:0] reg_address = 0;
	reg [31:0] reg_wr_data = 0;
	reg reg_wr_en = 0;
	reg cmd_from_sd=1;
	reg req = 0;

	//Para respuesta cmd
	reg start_sending_response = 0;
	reg [47:0] cmd_response = 48'h19FA_FADB_DBF3;
	wire finished_parallel_to_serial;
	wire serial_out;
	
	
	
	parallel_to_serial parallel_to_serial_1 (.CLK(CLK_card), .start_sending(start_sending_response), .parallel_in(cmd_response), .finished(finished_parallel_to_serial), .serial_out(serial_out) );

   initial begin
      CLK 	= 1'b1;
      CLK_card 	= 1'b1;
      RESET 	= 1'b1;
      #8 RESET 	= 1'b0;
      
      //CMD
      #2 reg_address = 12'h008;
	req = 1;
	reg_wr_en=1;
      reg_wr_data = 32'h0000_3210;
      #2 reg_address = 12'h00A;
      reg_wr_data = 32'h0000_7654;
      #2 reg_address = 12'h00E; //aqui empieza a funcionar el sd_host pues start_flag se activa
      reg_wr_data = 32'b0000_0000_0000_0000_0001_1001_0011_0111;
      
      #426 start_sending_response = 1; //empezar a enviar la respuesta del comando
      
      
      
      
      
      

   end
   
   	always @(*) begin
		if (start_sending_response == 1) begin
			cmd_from_sd = serial_out;
		end
		else begin
			cmd_from_sd = 1;
		end
				
	
	end
   
   

   always #(1) CLK  <= !CLK;
   always #(4) CLK_card <= !CLK_card;
   
endmodule
