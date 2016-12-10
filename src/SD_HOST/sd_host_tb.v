////////////////////////////////////////////////////////
// File: sd_host_tb (Testbench)
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////

`define SD_HOST_COMPLETE

`include "sd_host.v"
`include "ADMA/modules/ram.v"
`include "sd_host_tester.v"

module sd_host_tb;

   wire HOST_clk;
   wire SD_clk;
   wire RESET;
   wire RST_L;
   
   wire STOP;
   wire [31:0] data_ram_host;
   wire [31:0] data_host_ram;
   wire [63:0] ram_address;
   wire        ram_read_enable;
   wire        ram_write_enable;
   
   wire        cmd_to_card;
   wire        cmd_to_card_oe;
   wire        cmd_from_card;
   wire [3:0]  data_to_card;
   wire        data_to_card_oe;
   wire [3:0]  data_from_card;
   

   wire [31:0]     reg_wr_data;
   wire [31:0] 	   reg_rd_data;
   wire [11:0] 	   reg_address;
   wire		   reg_wr_data_en;
   wire		   req;

   
   assign RST_L=~RESET;
   
   sd_host_tester sdh_tester0 (.CLK(HOST_clk),
			       .CLK_card(SD_clk),
			       .RESET(RESET),
			       .data_from_card(data_from_card),
			       .reg_wr_data(reg_wr_data),
		     	       .reg_wr_en(reg_wr_data_en),
		     	       .reg_address(reg_address),

			       .req(req),

		     	       .cmd_from_sd(cmd_from_sd)
			       );
   
   sd_host sd_host0 (.CLK(HOST_clk),
		     .RESET(RESET),
		     .CLK_card(SD_clk),
		     .STOP(STOP),
		     .data_from_ram(data_ram_host),
		     .data_from_card(data_from_card),
		     .cmd_from_card(cmd_from_sd),
		     .data_to_ram(data_host_ram),
		     .ram_address(ram_address),
		     .ram_read_enable(ram_read_enable),
		     .ram_write_enable(ram_write_enable),
		     .cmd_to_card(cmd_to_card),
		     .cmd_to_card_oe(cmd_to_card_oe),
		     .data_to_card(data_to_card),
		     .data_to_card_oe(data_to_card_oe),
		     .reg_wr_data(reg_wr_data),
		     .reg_wr_en(reg_wr_data_en),
		     .req(req),
		     .reg_address(reg_address)
		     );
   
   ram ram(.CLK(HOST_clk),
	   .address(ram_address),
	   .data_in(data_host_ram),
	   .write(ram_write_enable),
	   .read(ram_read_enable),
	   .data_out(data_ram_host)
	   );
   

   initial begin
      $dumpfile("sim/sd_host_test.vcd");
      $dumpvars(0,sd_host_tb);
      #(4000) $finish;
   end

   initial begin 
      $monitor("t=%t", $time); 
   end

endmodule
