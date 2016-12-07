////////////////////////////////////////////////////////
// Module: sd_host
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////


`include "defines.v"

`include "ADMA/modules/dma.v"
`include "CMD/modules/CMD.v"
`include "DAT/modules/DAT.v"
`include "buffer/buffer_wrapper.v"
`include "REG/cpu_communication.v"
`include "REG/modules/regs.v"
`include "start_detect.v"


module sd_host(input         CLK,
	       input 	     RESET,
	       input 	     CLK_card,
	       input 	     STOP, //core signal to stop transfer with ram
	       input [31:0]  data_from_ram, 
	       input [3:0]   data_from_card,
	       input [11:0]  reg_address,
	       input [31:0]  reg_wr_data,
	       input 	     cmd_from_card,
	       input        reg_wr_en,
	       output [31:0] reg_rd_data,
	       output [31:0] data_to_ram,
	       output [63:0] ram_address,
	       output 	     ram_read_enable,
	       output 	     ram_write_enable,
	       output 	     cmd_to_card,
	       output 	     cmd_to_card_oe,
	       output [3:0]  data_to_card,
	       output 	     data_to_card_oe
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
   wire 		     sd_card_busy;
   
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
   // Enables de los registros
   wire [31:0] 		     PSR_En;
   wire [15:0] 		     NISR_En;
   wire [15:0] 		     TMR_En;
   wire [15:0] 		     BCR_En;
   wire [15:0] 		     BSR_En;
   wire [63:0] 		     ADMASAR_En;
   wire [15:0] 		     EISR_En;
   wire [15:0] 		     CR_En;
   wire [15:0] 		     BGCR_En;
   wire [15:0] 		     A0R_En;
   wire [15:0] 		     A1R_En;
   wire [15:0] 		     R0R_En;
   wire [15:0] 		     R1R_En;

   
   assign not_reset=~RESET;
   
   //--------------------------------------------------REG-------------------------------
   cpu_reg_communication CPU_reg 			 (.rd_data(reg_rd_data), 
   														.wr_data(reg_wr_data), 
   														.addrs(reg_address),
   														.wr_valid(reg_wr_en),
   														.out_00Eh(CR_wr)
   														);
   
   
   

   //------------REG---------------------------------------------------------------------
   //dat
   reg_32 Present_State_Register           (.clk(CLK),.reset(RESET),.wr_data(PSR_wr),    .rd_data(PSR_rd),  .enb(PSR_En)    );   
   reg_16 Normal_Interrupt_Status_Register (.clk(CLK),.reset(RESET),.wr_data(NISR_wr),   .rd_data(NISR_rd), .enb(NISR_En)  );
   reg_16 Transfer_Mode_Register           (.clk(CLK),.reset(RESET),.wr_data(TMR_wr),    .rd_data(TMR_rd),  .enb(TMR_En)  ); 
   reg_16 Block_Count_Register             (.clk(CLK),.reset(RESET),.wr_data(BCR_wr),    .rd_data(BCR_rd),  .enb(BCR_En) );
   reg_16 Block_Size_Register              (.clk(CLK),.reset(RESET),.wr_data(BSR_wr),    .rd_data(BSR_rd),  .enb(BSR_En)  );
   //dma   
   reg_64 ADMA_System_Address_Register     (.clk(CLK),.reset(RESET),.wr_data(ADMASAR_wr),.rd_data(ADMASAR_rd), .enb(ADMASAR_En));
   reg_16 Error_ADMA_Status                (.clk(CLK),.reset(RESET),.wr_data(EISR_wr),   .rd_data(EISR_rd), .enb(EISR_En)   );
   reg_16 Command_Register                 (.clk(CLK),.reset(RESET),.wr_data(CR_wr),     .rd_data(CR_rd) ,  .enb(CR_En) );
   reg_16 Block_Gap_Control_Register       (.clk(CLK),.reset(RESET),.wr_data(BGCR_wr),   .rd_data(BGCR_rd), .enb(BGCR_En)   );
   //cmd
   reg_16 Argument0_Register               (.clk(CLK),.reset(RESET),.wr_data(A0R_wr),    .rd_data(A0R_rd), .enb(A0R_En) );
   reg_16 Argument1_Register               (.clk(CLK),.reset(RESET),.wr_data(A1R_wr),    .rd_data(A1R_rd), .enb(A1R_En)    );
   reg_16 Response0_Register               (.clk(CLK),.reset(RESET),.wr_data(R0R_wr),    .rd_data(R0R_rd), .enb(R0R_En)   );
   reg_16 Response1_Register               (.clk(CLK),.reset(RESET),.wr_data(R1R_wr),    .rd_data(R1R_rd), .enb(R1R_En) );
   reg_16 Error_Interrupt_Status_Register  (.clk(CLK),.reset(RESET),.wr_data(EISR_wr),   .rd_data(EISR_rd), .enb(EISR_En)   );

   //logic for ADMA------------------------------------------------------
   
   dma dma(
   	   .RESET(RESET),
   	   .CLK(CLK),
   	   .adma_address_register_0(ADMASAR_rd[15:0]),
   	   .adma_address_register_1(ADMASAR_rd[31:16]),
   	   .adma_address_register_2(ADMASAR_rd[47:32]),
   	   .adma_address_register_3(ADMASAR_rd[63:48]),
   	   .command_register(CR_rd),
	   .start_flag(start_flag),
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

   wire [31:0] 		     cmd_arg;
   assign cmd_arg = {A1R_rd,A0R_rd};
   wire [31:0] 		     response_status;
   assign response_status = {R1R_rd, R0R_rd};
   wire [31:0]					response_status_en;
   assign response_status_en = {R1R_En, R0R_En} ;
	
   CMD CMD_0 (.reset(RESET), 
	      .CLK_host(CLK), 
	      .new_cmd(start_flag), 
	      .cmd_arg(cmd_arg), 
	      .cmd_index(CR_rd[13:8]), 
	      .cmd_from_sd(cmd_from_card), 
	      .CLK_SD_card(CLK_card), 
	      .cmd_busy(PSR_wr[0]),
	      .cmd_complete(NISR_wr[0]), 
	      .timeout_error(EISR_wr[0]),
	      .response_status(response_status), 
	      .cmd_to_sd(cmd_to_card), 
	      .cmd_to_sd_oe(cmd_to_card_oe),
	      .cmd_busy_en(PSR_En[0]),
	      .cmd_complete_en(NISR_En[0]),
	      .timeout_error_en(EISR_En[0]),
	      .response_status_en(response_status_en)
	      );
	

   //logic for DAT------------------------------------------------------

   wire [2:0] 		     DAT_PSR_wr_enb;
   assign DAT_PSR_wr_enb = {PSR_En[9], PSR_En[8], PSR_En[1]}; 
   
   DAT DAT_0 (.host_clk(CLK),
	      .sd_clk(CLK_card),
	      .rst_L(not_reset),
	      .resp_recv(resp_recv),
	      .tx_buf_empty(buffer_dat_empty),
	      .rx_buf_full(buffer_dat_full),
	      .tx_buf_dout_in(data_buffer_to_dat),
	      .DAT_din(data_from_card),
	      .block_sz_reg(BSR_rd[11:0]),
	      .block_cnt_reg(BCR_wr),
	      .multiple_blk_reg(TMR_rd[5]),
	      .tf_direction_reg(TMR_rd[4]),
	      .wr_tf_active_reg(PSR_wr[8]),
	      .rd_tf_active_reg(PSR_wr[9]),
	      .cmd_inhibit_dat_reg(PSR_wr[1]),
	      .PSR_wr_enb(DAT_PSR_wr_enb),
	      .tf_complete_reg(NISR_wr[1]),
	      .NISR_wr_enb(NISR_En[1]),
	      .tx_buf_rd_enb(buffer_dat_read),
	      .rx_buf_wr_enb(buffer_dat_write),
	      .rx_buf_din_out(data_dat_to_buffer),
	      .DAT_dout(data_to_card),
	      .DAT_dout_oe(data_to_card_oe),
	      .sdc_busy_L(sd_card_busy)
	      );

   
   //logic for fifo------------------------------------------------------      
   
   buffer_wrapper buffer_wrapper(.host_clk(CLK_card),
				 .sd_clk(CLK),
				 .rst_L(not_reset),
				 .rx_buf_rd_host(buffer_dma_read),//dma
				 .tx_buf_wr_host(buffer_dma_write),//dma
				 .rx_buf_wr_dat(buffer_dat_write),//dat
				 .tx_buf_rd_dat(buffer_dat_read),//dat
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
			     .command_register(CR_rd[15:10]),
			     .start_flag(start_flag));
   
   
endmodule // sd_host


