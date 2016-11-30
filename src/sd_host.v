////////////////////////////////////////////////////////
// Module: sd_host
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////


`include "defines.v"

`include "ADMA/modules/dma.v"
`include "CMD/CMD_TLB.v"
`include "DAT/modules/buffer_wraper.v"
`include "DAT/modules/dat_phys.v"
`include "DAT/modules/dat_control.v"

//FIXME: find the appropiate include for registers


module sd_host(input CLK,
	       input RESET,
	       input CLK_card);


endmodule // sd_host


