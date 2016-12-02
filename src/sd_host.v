////////////////////////////////////////////////////////
// Module: sd_host
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////


`include "defines.v"

`include "ADMA/modules/dma.v"
`include "CMD/modules/CMD.v"
`include "buffer/buffer_wrapper.v"

//`include "DAT/modules/dat_phys.v"
//`include "DAT/modules/dat_control.v"
`include "REG/regs.v"

//`include "DAT/modules/DAT.v"

//FIXME: find the appropiate include for registers



module sd_host(input CLK,

	       input 	     RESET,
	       input 	     CLK_card,
	              
	       input 	     STOP, //core signal to stop transfer with ram
	       input [31:0]  data_from_ram, 
	       input [3:0]   data_from_card,
	       output [31:0] data_to_ram,
	       output [63:0] ram_address,
	       output 	     command_to_card,
	       output [3:0]  data_to_card,
	       );

   //logic for ADMA------------------------------------------------------



   //logic for CMD-------------------------------------------------------
	
	CMD CMD_0 (.reset(RESET), .CLK_host(CLK), .new_cmd(CR_rd[15]), .cmd_arg(cmd_arg), .cmd_index(CR_rd[13:8]), .cmd_from_sd(cmd_from_card), .CLK_SD_card(CLK_card), .cmd_busy(cmd_busy), .cmd_complete(NISR_wr[0]), .timeout_error(timeout_error), .response_status(response_status), .cmd_to_sd(cmd_to_card), .cmd_to_sd_oe(cmd_to_sd_oe) );
	wire [31:0] cmd_arg;
	assign cmd_arg = {A1R_rd, A0R_rd};
	wire [31:0] response_status;
	assign response_status = {R1R_rd, R0R_rd};
	


   //logic for DAT------------------------------------------------------

   //logic for fifo------------------------------------------------------   


   //dma dma();


   //REGS

   //Zamo
   wire [31:0] PSR_wr;
   wire [31:0] PSR_rd;
   reg_32 Present_State_Register(.clk(CLK),.reset(RESET),.wr_data(PSR_wr),.rd_data(PSR_rd));

   wire [15:0] NISR_wr;
   wire [15:0] NISR_rd;
   reg_16 Normal_Interrupt_Status_Register (.clk(CLK),.reset(RESET),.wr_data(NISR_wr),.rd_data(NISR_rd));

   wire [15:0] TMR_wr;
   wire [15:0] TMR_rd;
   reg_16 Transfer_Mode_Register (.clk(CLK),.reset(RESET),.wr_data(TMR_wr),.rd_data(TMR_rd)); 

   wire [15:0] BCR_wr;
   wire [15:0] BCR_rd;
   reg_16 Block_Count_Register (.clk(CLK),.reset(RESET),.wr_data(BCR_wr),.rd_data(BCR_rd));

   wire [15:0] BSR_wr;
   wire [15:0] BSR_rd;
   reg_16 Block_Size_Register (.clk(CLK),.reset(RESET),.wr_data(BSR_wr),.rd_data(BSR_rd));

   //Daneil (Maestro)
   wire [63:0] ADMASAR_wr;
   wire [63:0] ADMASAR_rd;
   reg_64 ADMA_System_Address_Register (.clk(CLK),.reset(RESET),.wr_data(ADMASAR_wr),.rd_data(ADMASAR_rd));

   wire [31:0] EISR_wr;
   wire [31:0] EISR_rd;
   reg_32 Error_Interrupt_Status_Register (.clk(CLK),.reset(RESET),.wr_data(EISR_wr),.rd_data(EISR_rd));

   wire [15:0] CR_wr;
   wire [15:0] CR_rd;
   reg_16 Command_Register (.clk(CLK),.reset(RESET),.wr_data(CR_wr),.rd_data(CR_rd));

   wire [7:0]  BGCR_wr;
   wire [7:0]  BGCR_rd;
   reg_8 Block_Gap_Control_Register (.clk(CLK),.reset(RESET),.wr_data(BGCR_wr),.rd_data(BGCR_rd));


   // Danielooon !!!

   wire [15:0] A0R_wr;
   wire [15:0] A0R_rd;
   reg_16 Argument0_Register(.clk(CLK),.reset(RESET),.wr_data(A0R_wr),.rd_data(A0R_rd));

   wire [15:0] A1R_wr;
   wire [15:0] A1R_rd;
   reg_16 Argument1_Register(.clk(CLK),.reset(RESET),.wr_data(A1R_wr),.rd_data(A1R_rd));

   wire [15:0] R0R_wr;
   wire [15:0] R0R_rd;
   reg_16 Response0_Register(.clk(CLK),.reset(RESET),.wr_data(R0R_wr),.rd_data(R0R_rd));

   wire [15:0] R1R_wr;
   wire [15:0] R1R_rd;
   reg_16 Response1_Register(.clk(CLK),.reset(RESET),.wr_data(R1R_wr),.rd_data(R1R_rd));


endmodule // sd_host


