////////////////////////////////////////////////////////
// Module: sd_host
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////


`include "defines.v"

`include "ADMA/modules/dma.v"
//`include "CMD/CMD_TLB.v"
`include "DAT/modules/DAT.v"
`include "buffer/buffer_wrapper.v"

`include "REG/regs.v"
`include "start_detect.v"
//FIXME: find the appropiate include for registers



module sd_host(input CLK,
	       input 	     RESET,
	       input 	     CLK_card,
	       input 	     STOP, //core signal to stop transfer with ram
	       input [31:0]  data_from_ram, 
	       input [3:0]   data_from_card,
	       input 	     cmd_from_card,
	       output [31:0] data_to_ram,
	       output [63:0] ram_address,
	       output 	     ram_read_enable,
	       output 	     ram_write_enable,
	       output 	     cmd_to_card,
	       output [3:0]  data_to_card
	       );

   wire 		     buffer_dma_full;
   wire 		     buffer_dma_empty;
   wire [31:0] 		     data_buffer_to_dma;
   wire [31:0] 		     data_dma_to_buffer;
   wire 		     ram_read;
   wire 		     ram_write;
   wire 		     buffer_dma_read;
   wire 		     buffer_dma_write;
   wire 		     start_transfer;
   wire 		     void_dma;

   wire 		     buffer_dat_read;
   wire 		     buffer_dat_write;
   wire [31:0] 		     data_buffer_to_dat;
   wire [31:0] 		     data_dat_to_buffer;
   wire 		     buffer_dat_empty;
   wire 		     buffer_dat_full;
   
   wire [31:0] 		     PSR_wr;
   wire [31:0] 		     PSR_rd;
   wire [15:0] 		     NISR_wr;
   wire [15:0] 		     NISR_rd;
   wire [15:0] 		     TMR_wr;
   wire [15:0] 		     TMR_rd;
   wire [15:0] 		     BCR_wr;
   wire [15:0] 		     BCR_rd;
   wire [15:0] 		     BSR_wr;
   wire [15:0] 		     BSR_rd;
   wire [63:0] 		     ADMASAR_wr;
   wire [63:0] 		     ADMASAR_rd;
   wire [15:0] 		     EISR_wr;
   wire [15:0] 		     EISR_rd;
   wire [15:0] 		     CR_wr;
   wire [15:0] 		     CR_rd;
   wire [15:0] 		     BGCR_wr;
   wire [15:0] 		     BGCR_rd; 
   wire [15:0] 		     A0R_wr;
   wire [15:0] 		     A0R_rd;
   wire [15:0] 		     A1R_wr;
   wire [15:0] 		     A1R_rd;
   wire [15:0] 		     R0R_wr;
   wire [15:0] 		     R0R_rd;
   wire [15:0] 		     R1R_wr;
   wire [15:0] 		     R1R_rd;
   wire 		     start_flag;
   
   
   assign not_reset=~RESET;

   

   //------------REG---------------------------------------------------------------------
   //dat
   reg_32 Present_State_Register           (.clk(CLK),.reset(RESET),.wr_data(PSR_wr),    .rd_data(PSR_rd)    );   
   reg_16 Normal_Interrupt_Status_Register (.clk(CLK),.reset(RESET),.wr_data(NISR_wr),   .rd_data(NISR_rd)   );
   reg_16 Transfer_Mode_Register           (.clk(CLK),.reset(RESET),.wr_data(TMR_wr),    .rd_data(TMR_rd)    ); 
   reg_16 Block_Count_Register             (.clk(CLK),.reset(RESET),.wr_data(BCR_wr),    .rd_data(BCR_rd)    );
   reg_16 Block_Size_Register              (.clk(CLK),.reset(RESET),.wr_data(BSR_wr),    .rd_data(BSR_rd)    );
   //dma   
   reg_64 ADMA_System_Address_Register     (.clk(CLK),.reset(RESET),.wr_data(ADMASAR_wr),.rd_data(ADMASAR_rd));
   reg_16 Error_ADMA_Status                (.clk(CLK),.reset(RESET),.wr_data(EISR_wr),   .rd_data(EISR_rd)   );
   reg_16 Command_Register                 (.clk(CLK),.reset(RESET),.wr_data(CR_wr),     .rd_data(CR_rd)     );
   reg_16 Block_Gap_Control_Register       (.clk(CLK),.reset(RESET),.wr_data(BGCR_wr),   .rd_data(BGCR_rd)   );
   //cmd
   reg_16 Argument0_Register               (.clk(CLK),.reset(RESET),.wr_data(A0R_wr),    .rd_data(A0R_rd)    );
   reg_16 Argument1_Register               (.clk(CLK),.reset(RESET),.wr_data(A1R_wr),    .rd_data(A1R_rd)    );
   reg_16 Response0_Register               (.clk(CLK),.reset(RESET),.wr_data(R0R_wr),    .rd_data(R0R_rd)    );
   reg_16 Response1_Register               (.clk(CLK),.reset(RESET),.wr_data(R1R_wr),    .rd_data(R1R_rd)    );

   //logic for ADMA------------------------------------------------------
   
   dma dma(
   	   .RESET(RESET),
   	   .CLK(CLK),
   	   .adma_address_register_0(ADMASAR_rd[15:0]),
   	   .adma_address_register_1(ADMASAR_rd[31:16]),
   	   .adma_address_register_2(ADMASAR_rd[47:32]),
   	   .adma_address_register_3(ADMASAR_rd[63:48]),
   	   .command_register(CR_rd),
   	   .block_gap_control_register(BGCR_rd),
   	   .block_size_register(BSR_rd),
   	   .block_count_register(BCR_rd),
   	   .transfer_mode_register_in(TMR_rd),
	   .data_from_ram(data_from_ram),
	   .data_from_fifo(data_buffer_to_dma),//
	   .fifo_full(buffer_dma_full),//
	   .fifo_empty(buffer_dma_empty),//
	   .error_adma_register(EISR_wr),
	   .data_to_ram(data_to_ram),
	   .data_to_fifo(data_dma_to_buffer),//
	   .ram_address(ram_address),
	   .ram_read(ram_read_enable),
	   .ram_write(ram_write_enable),
	   .fifo_read(buffer_dma_read),//
	   .fifo_write(buffer_dma_write),//
	   .start_transfer(start_transfer),
	   .enable_write(void_dma)
   	   );
   
   //logic for CMD-------------------------------------------------------

   //logic for DAT------------------------------------------------------

   //logic for fifo------------------------------------------------------      
   
   buffer_wrapper buffer_wrapper(.host_clk(CLK_card),
				 .sd_clk(CLK),
				 .rst_L(not_reset),
				 .rx_buf_rd_host(buffer_dma_read),//dma
				 .tx_buf_wr_host(buffer_dma_write),//dma
				 .rx_buf_wr_dat(buffer_dat_read),//dat
				 .tx_buf_rd_dat(buffer_dat_write),//dat
				 .rx_buf_din(data_dat_to_buffer),//dat
				 .tx_buf_din(data_dma_to_buffer),//dma
				 .rx_buf_dout(data_buffer_to_dma),//dma
				 .tx_buf_dout(data_buffer_to_dat),//dat
				 .tx_buf_empty(buffer_dat_empty),//dat
				 .tx_buf_full(buffer_dma_full),//dma
				 .rx_buf_empty(buffer_dma_empty),//dma
				 .rx_buf_full(buffer_dat_full)//dat
				 );

   //-----------START_FLAG------------------------------------------
   start_detect start_detect(.clk(CLK),
			     .reset(RESET),
			     .command_register(CR_rd[15:9]),
			     .start_flag(start_flag));
   
   
endmodule // sd_host


