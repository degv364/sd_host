////////////////////////////////////////////////////////
// File: sd_host_tester
// Authors: Ariel Fallas Pizarro, Daniel Garcia Vaglio, Daniel Piedra Perez, Esteban Zamora Alvarado
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "defines.v"

`timescale 1ns/10ps

/*
 En este módulo se establecen las señales y registros necesarias para las pruebas 
 de lectura y escritura de tramas en el SD Host.
 */
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
	integer 			   i;
   	integer 			   j;      


   


   
   parallel_to_serial parallel_to_serial_1 (.CLK(CLK_card), 
					    .start_sending(start_sending_response), 
					    .parallel_in(cmd_response), 
					    .finished(finished_parallel_to_serial), 
					    .serial_out(serial_out) 
					    );

   parameter BLK_SIZE = 32'h0000_0040; //64
   parameter BLK_CNT  = 32'h0000_000A; //10
   
   initial begin
      
      CLK 	      = 1'b1;
      CLK_card 	      = 1'b1;
      RESET 	      = 1'b1;
      cmd_response = 48'h19FA_FADB_DBF3; //Respuesta de CMD para lectura de múltiples bloques
      start_sending_response = 0;
      data_from_card = 4'b1111; //Línea de datos por defecto en alto
      
      #8 RESET 	      = 1'b0;
      
      //-------------------WRITE----------------------
`ifdef WRITE
      //DAT
      #2 reg_address  = 12'h004; //Block size
      req = 1;
      reg_wr_en=1;
      reg_wr_data     = BLK_SIZE;
      #2 reg_address  = 12'h006; //Block count
      reg_wr_data     = BLK_CNT;
      #2 reg_address  = 12'h00C; //Transfer mode
      reg_wr_data     = 32'h0000_0023;//2={1:Multiple,0:Write},3={1:Blk_cnt_en,1:DMA_en}
      
      //CMD
      #2 reg_address = 12'h008;

      reg_wr_data = 32'h0000_3210;
      #2 reg_address = 12'h00A;
      reg_wr_data = 32'h0000_7654;
      #2 reg_address = 12'h00E; //Aqui empieza a funcionar el sd_host pues start_flag se activa

      
      reg_wr_data     = 32'b0000_0000_0000_0000_0001_1001_0011_0011;

      #6
      #432 start_sending_response = 1; //Empezar a enviar la respuesta del comando
      
      cmd_response = 48'h12FA_FADB_DBF3; //Respuesta de CMD para lectura de múltiples bloques
      
      //-------------------READ----------------------
`else
      #8 start_sending_response = 0;
      req = 1;
      reg_wr_en=1;

      //DAT
      #2 reg_address  = 12'h004; //Block size
      reg_wr_data 	 = BLK_SIZE;
      #2 reg_address 	 = 12'h006; //Block count
      reg_wr_data 	 = BLK_CNT;
      #2 reg_address 	 = 12'h00C; //Transfer mode
      reg_wr_data 	 = 32'h0000_0033; //2={1:Multiple,1:Read},3={1:Blk_cnt_en,1:DMA_en}
      
      //CMD
      #2 reg_address 	 = 12'h008;
      reg_wr_data 	 = 32'h0000_2140;
      #2 reg_address 	 = 12'h00A;
      reg_wr_data 	 = 32'h0000_8310;
      #2 reg_address 	 = 12'h00E; //Aqui empieza a funcionar el sd_host pues start_flag se activa
      reg_wr_data 	 = 32'b0000_0000_0000_0000_0001_0010_0011_0011;

      #436 start_sending_response = 1;

      #504
      //Envío de datos desde el SD Card
      #(10*8) for(i=0; i<BLK_CNT; i=i+1) begin
	 #(10*8) data_from_card <= 4'h0; //Secuencia de inicio
	 for(j=0; j<BLK_SIZE/4; j=j+1) begin //Data
	    #(8) data_from_card  <= 4'h1+j;
	 end
	 #(8) data_from_card  <= 4'hC; //Secuencia CRC
	 #(8) data_from_card  <= 4'hC;
	 #(8) data_from_card  <= 4'hF; //Secuencia END
      end
`endif

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
