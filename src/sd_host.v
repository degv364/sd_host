////////////////////////////////////////////////////////
// Module: sd_host
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////


`include "defines.v"

`include "ADMA/modules/dma.v"
`include "CMD/CMD_TLB.v"
`include "buffer/buffer_wraper.v"
`include "DAT/modules/dat_phys.v"
`include "DAT/modules/dat_control.v"
//FIXME: find the appropiate include for registers



module sd_host(input CLK,
	       input 	     RESET,
	       input 	     CLK_card,
	       input 	     STOP, //core signal to stop transfer with ram
	       input [31:0]  data_from_ram, 
	       input [3:0]   data_from_card
	       output [31:0] data_to_ram,
	       output [63:0] ram_address 
	       output 	     command_to_card,
	       output [3:0]  data_to_card
	       );

   //logic for ADMA------------------------------------------------------



   //logic for CMD-------------------------------------------------------

   //logic for DAT------------------------------------------------------

   //logic for fifo------------------------------------------------------

   


   dma dma();
   

   
endmodule // sd_host


