////////////////////////////////////////////////////////
// File: sd_host_tb (Testbench)
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio,
// Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "sd_host.v"
`include "sd_host_tester.v"
//FIXME: Add wires and modules ports

module sd_host_tb;

   wire HOST_clk;
   wire SD_clk;
   wire RST_L;

   sd_host_tester sdh_tester0 ();
   sd_host sd_host0 ();

   initial begin
      $dumpfile("sd_host_test.vcd");
      $dumpvars(0,sd_host_tb);
      #(2000) $finish;
   end

   initial begin 
      $monitor("t=%t", $time); 
   end

endmodule
