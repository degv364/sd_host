////////////////////////////////////////////////////////
// Module: dat_tester (Stimulus)
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "../defines.v"

`timescale 1ns/10ps

/*
Módulo probador para verificar el funcionamiento adecuado del módulo de DAT (DAT_control y DAT_phys)

 -Se simula la escritura al FIFO Tx por parte del DMA para luego leer bloques de 32 bits de este
 FIFO y transmitir bloques de 4 bits a la tarjeta SD.
 
 -También se simula la escritura de datos por parte de la tarjeta SD para probar las transacciones
 de lectura.
*/
module DAT_tester(
		  input 			    tx_buf_full,
		  input 			    rx_buf_empty,
		  output reg 			    host_clk,
		  output reg 			    sd_clk,
		  output reg 			    rst_L,
		  output reg 			    resp_recv,
		  output reg [3:0] 		    DAT_din,
		  output reg [`BLOCK_SZ_WIDTH-1:0]  block_sz_reg,
		  output reg [`BLOCK_CNT_WIDTH-1:0] block_cnt_reg,
		  output reg 			    multiple_blk_reg,
		  output reg 			    tf_direction_reg,
		  output reg 			    rx_buf_rd_host,
		  output reg 			    tx_buf_wr_host,
		  output reg [`FIFO_WIDTH-1:0] 	    tx_buf_din_out
		  );

   integer i;
   integer j;
   
   initial begin
      host_clk 		= 1'b1;
      sd_clk 		= 1'b1;
      rst_L 		= 1'b1;
      rx_buf_rd_host 	= 1'b0;
      tx_buf_wr_host 	= 1'b0;
      DAT_din 		= 4'b1111; //DAT line default
      tx_buf_din_out 	= 0;
      resp_recv 	= 0;
      
      //Register related
      block_cnt_reg 	= 4;
      block_sz_reg 	= 64;
      multiple_blk_reg 	= 1;
      tf_direction_reg 	= 0; //Write
      
      #2 rst_L 		= 1'b0;
      #10 rst_L 	= 1'b1;

      //---- Write Transaction ----

      #2 for (i=0; i<=15; i=i+1) begin //Fill 16 32-bit blocks into Tx Buffer
	 #2 tx_buf_din_out  = `FIFO_WIDTH'h1234ABCD+i;
	 tx_buf_wr_host = 1; 
      end
      #2 tx_buf_wr_host  = 0;
      
      #2 resp_recv 	 = 1;
      #2 resp_recv 	 = 0;

      //---- Read Transaction ----

      #700 tf_direction_reg = 1;
      resp_recv = 1;
      #2 resp_recv = 0; //FIXME: Check if should change to 2
      #6
      //SD Card sending data
      #(10*8) for(i=0; i<block_cnt_reg; i=i+1) begin
	 #(10*8) DAT_din <= 4'h0; //Start Sequence
	 for(j=0; j<block_sz_reg/4; j=j+1) begin //Data
	    #(8) DAT_din  <= 4'h1+j;
	 end
	 #(8) DAT_din  <= 4'hC; //CRC Sequence
	 #(8) DAT_din  <= 4'hC;
	 #(8) DAT_din  <= 4'hF; //End Sequence
      end
   end

   always #(1) host_clk  = !host_clk;
   always #(4) sd_clk = !sd_clk;

endmodule
