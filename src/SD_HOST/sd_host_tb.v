////////////////////////////////////////////////////////
// File: sd_host_tb (Testbench)
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "sd_host.v"
`include "ADMA/modules/ram.v"
`include "sd_host_tester.v"
//FIXME: Add wires and modules ports

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
   
   wire [31:0]       wr_data;
   wire [31:0] 	     rd_data;
   wire [12:0] 	     address;
   
   
   assign RST_L=~RESET;
   
   sd_host_tester sdh_tester0 (.CLK(HOST_clk),
			       .CLK_card(SD_clk),
			       .RESET(RESET),
			       .data_from_card(data_from_card)
			       );
   
   sd_host sd_host0 (.CLK(HOST_clk),
		     .RESET(RESET),
		     .CLK_card(SD_clk),
		     .STOP(STOP),
		     .data_from_ram(data_ram_host),
		     .data_from_card(data_from_card),
		     .addrs(address),
		     .wr_data(wr_data),
		     .cmd_from_card(cmd_from_card),
		     .rd_data(rd_data),
		     .data_to_ram(data_host_ram),
		     .ram_address(ram_address),
		     .ram_read_enable(ram_read_enable),
		     .ram_write_enable(ram_write_enable),
		     .cmd_to_card(cmd_to_card),
		     .cmd_to_card_oe(cmd_to_card_oe),
		     .data_to_card(data_to_card),
		     .data_to_card_oe(data_to_card_oe)
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
      #(2000) $finish;
   end

   initial begin 
      $monitor("t=%t", $time); 
   end

endmodule
