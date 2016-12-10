////////////////////////////////////////////////////////
// Module: DAT_phys
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "../../defines.v"

`timescale 1ns/10ps
/*
 Descripción:
 
 Módulo de capa física para el bloque DAT. Este módulo opera a la frecuencia de la tarjeta SD, y se
 encarga de efectuar la escritura o lectura de la línea de datos de 4 pines de la tarjeta, 
 iniciando el proceso según lo indique la capa de control de DAT e interactuando con el FIFO de
 lectura o escritura tal como corresponda.
 
 De esta forma, se toma la información de los registros de Block Count y Block Size, así como la
 señal de escritura/lectura de la capa de control (proveniente de Transfer Mode Register) para 
 determinar el comportamiento de este módulo.
 
 Tanto para las transacciones de escritura o lectura se emplea una variable denominada sel_offset, 
 la cual se utiliza como un puntero que permite recorrer los bloques de 32 bits empleados por los
 FIFOs (Tx y Rx), para escribir o leer en segmentos de 4 bits.
 
 Por otro lado, se utilizan los registros internos de curr_block_cnt y curr_block_sz para llevar
 un conteo de la cantidad de bloques y bits en un bloque que están aún por transmitir.
 
 Además, se tiene una salida de DAT_dout_oe (output enable), la cual permitiría controlar la 
 dirección del PAD que comunicaría al SD Host con los pines de la tarjeta.
*/

module DAT_phys (
		 input 			      sd_clk,         //Reloj tarjeta SD
		 input 			      rst_L,          //Reset
		 input [`FIFO_WIDTH-1:0]      tx_buf_dout_in, //Datos de salida del FIFO de Tx
		 input [3:0] 		      DAT_din,        //Entrada de pines de DAT [3:0]
		 input [`BLOCK_SZ_WIDTH-1:0]  block_sz,       //Registro Block Size
		 input [`BLOCK_CNT_WIDTH-1:0] block_cnt,      //Registro Block Count
		 input 			      write_flag,     //Transacción de escritura
		 input 			      read_flag,      //Transacción de lectura
		 input 			      multiple,       //Transferencia multi-trama
		 output 		      tx_buf_rd_enb,  //Habilitar lectura FIFO Tx
		 output 		      rx_buf_wr_enb,  //Habilitar escritura FIFO Tx
		 output [`FIFO_WIDTH-1:0]     rx_buf_din_out, //Datos de entrada del FIFO de Rx
		 output [3:0] 		      DAT_dout,       //Salida de pines de DAT [3:0]
		 output 		      DAT_dout_oe,    //Output enable pines DAT
		 output 		      dat_phys_busy,  //Capa física ocupada
		 output 		      tf_finished,    //Se termina la transferencia
		 output 		      sdc_busy_L      //La tarjeta SD está ocupada
		 );

   /////// Parámetros
   //Estados FSM
   parameter IDLE  = 7'b0000001;
   parameter NEW_WRITE  = 7'b0000010;
   parameter SERIAL_WRITE  = 7'b0000100;
   parameter END_BLK_WRITE  = 7'b0001000;
   parameter NEW_READ  = 7'b0010000;
   parameter SERIAL_READ  = 7'b0100000;
   parameter END_BLK_READ  = 7'b1000000;
   
   //Otros
   parameter SIZE  = 7;
   
   /////// Declaración de regs
   //Salidas asincrónicas
   reg 					      tx_buf_rd_enb;
   reg [3:0] 				      DAT_dout;
   reg 					      DAT_dout_oe;
   reg 					      tf_finished;

   
   //Regs para señales Next para las salidas sincrónicas
   reg [3:0] 				      nxt_DAT_dout;
   reg 					      nxt_DAT_dout_oe;
   
   //Regs relacionados con el estado interno del bloque
   reg [SIZE-1:0] 			      state;
   reg [(`FIFO_WIDTH/4)-1:0] 		      sel_offset;
   reg [`BLOCK_CNT_WIDTH-1:0] 		      curr_block_cnt;
   reg [`BLOCK_SZ_WIDTH-1:0] 		      curr_block_sz;
   reg [`FIFO_WIDTH-1:0] 		      curr_tx_buf_dout_in;
   reg [`FIFO_WIDTH-1:0] 		      rx_buf_din_out;
   reg 					      rx_buf_wr_enb;
   reg 					      new_block;
   reg 					      write_flag_reg;
   reg 					      read_flag_reg;
   reg 					      multiple_reg;
   reg [1:0] 				      end_blk_write_cnt;


   //Regs para las señales del próximo estado
   reg [SIZE-1:0] 			      nxt_state;
   reg [(`FIFO_WIDTH/4)-1:0] 		      nxt_sel_offset;
   reg [`BLOCK_CNT_WIDTH-1:0] 		      nxt_curr_block_cnt;
   reg [`BLOCK_SZ_WIDTH-1:0] 		      nxt_curr_block_sz;
   reg [`FIFO_WIDTH-1:0] 		      nxt_curr_tx_buf_dout_in;
   reg [`FIFO_WIDTH-1:0] 		      nxt_rx_buf_din_out;
   reg 					      nxt_rx_buf_wr_enb;
   reg 					      nxt_new_block;
   reg [1:0] 				      nxt_end_blk_write_cnt;

   //Lógica combinacional sin estado
   assign sdc_busy_L  = !DAT_din[0] & !DAT_dout_oe;
   assign dat_phys_busy  = (state != IDLE);   
   
   //Actualización del estado 
   always @ (posedge sd_clk) begin
      if(!rst_L) begin
	 
	 //Reinicio salidas
	 DAT_dout 	     <= 0;
	 DAT_dout_oe 	     <= 0;
	 
	 //Reinicio registros de estado
	 state 		     <= IDLE;
	 curr_block_cnt      <= 0;
	 curr_block_sz 	     <= 0;
	 sel_offset 	     <= 0;
	 curr_tx_buf_dout_in <= 0;
	 rx_buf_din_out      <= 0;
	 rx_buf_wr_enb 	     <= 0;
	 
	 new_block 	     <= 0;
	 end_blk_write_cnt   <= 0;

	 //Registros de entrada (almacenan en cada flanco el valor de la señales de entrada)
	 write_flag_reg      <= 0;
	 read_flag_reg 	     <= 0;
	 multiple_reg 	     <= 0;
      end
      else begin
	 //Actualización sincrónica al próximo estado
	 state 		     <= nxt_state;
	 sel_offset 	     <= nxt_sel_offset;
	 curr_block_cnt      <= nxt_curr_block_cnt;
	 curr_block_sz 	     <= nxt_curr_block_sz;
	 curr_tx_buf_dout_in <= nxt_curr_tx_buf_dout_in;
	 rx_buf_din_out      <= nxt_rx_buf_din_out;
	 rx_buf_wr_enb 	     <= nxt_rx_buf_wr_enb;
	 new_block 	     <= nxt_new_block;
	 end_blk_write_cnt   <= nxt_end_blk_write_cnt;
	 
	 //Captura sincrónica de las entradas del bloque
	 write_flag_reg      <= write_flag;
	 read_flag_reg 	     <= read_flag;
	 multiple_reg 	     <= multiple;
	 
	 //Actualización de las señales de salida sincrónica
	 DAT_dout 	     <= nxt_DAT_dout;
	 DAT_dout_oe 	     <= nxt_DAT_dout_oe;
      end
   end

   //Lógica del próximo estado y de salidas
   always @(*) begin
      //Valores de salidas por defecto
      tx_buf_rd_enb 	       = 0;
      tf_finished 	       = 0;
      nxt_DAT_dout 	       = 0;
      nxt_DAT_dout_oe 	       = DAT_dout_oe;
      
      //Valores de la lógica del próximo estado por defcto
      nxt_state 	       = state;
      nxt_sel_offset 	       = sel_offset;
      nxt_curr_block_cnt       = 0;
      nxt_curr_block_sz        = 0;
      nxt_curr_tx_buf_dout_in  = curr_tx_buf_dout_in;
      nxt_rx_buf_din_out       = rx_buf_din_out;
      nxt_rx_buf_wr_enb        = 0;
      nxt_new_block 	       = new_block;
      nxt_end_blk_write_cnt    = end_blk_write_cnt;
      
      case (state)
	 IDLE: begin
	    nxt_DAT_dout_oe = 0; //Salida de DAT deshabilitada por defecto
	    if(sdc_busy_L) begin //Si la tarjeta está ocupada conservar el estado IDLE
	       nxt_state = IDLE;
	    end
	    else begin
	       if(write_flag && !read_flag) begin //Inicio de la transacción de escritura
		  nxt_state 		   = NEW_WRITE;
		  nxt_new_block 	   = 1;
		  nxt_curr_tx_buf_dout_in  = tx_buf_dout_in;
		  nxt_sel_offset 	   = 0;		  
		  nxt_curr_block_cnt 	   = multiple_reg ? block_cnt : 1;
		  nxt_curr_block_sz 	   = block_sz;
	       end
	       else begin
		  if(read_flag && !write_flag) begin //Inicio de la transacción de lectura
		     nxt_state 		 = NEW_READ;
		     nxt_new_block 	 = 1;
		     nxt_sel_offset 	 = 0;		  
		     nxt_curr_block_cnt  = multiple_reg ? block_cnt : 1;
		     nxt_curr_block_sz 	 = block_sz;
		  end
		  else begin
		     nxt_state 	= IDLE;
    		  end
	       end
	    end
	 end
//------------------------------ Transacción WRITE ----------------------------
	 /*Se requiere tomar un nuevo bloque de 32 bits del FIFO Tx para transmitir
	 a la tarjeta SD*/
	 NEW_WRITE: begin
	    nxt_curr_block_cnt 	= curr_block_cnt;
	    nxt_curr_block_sz 	= curr_block_sz;
	     
	    if(new_block && sdc_busy_L) begin
	       nxt_state      = NEW_WRITE;
	       nxt_new_block  = 1; //Si la tarjeta está ocupada reintentar la operación de escritura
	    end
	    else begin  //Tarjeta SD no ocupada
	       //----------Secuencia de inicio o intermedia de un bloque----------
	       /*Nota: Los bloques podrían ser por ejemplo de 512 bits pero se extraen los
	       datos del FIFO de 32 en 32 bits, por lo que hay caso de inicio y uno intermedio*/
	       
		if(write_flag) begin //FIFO Tx no vacío
		  nxt_state 		   = SERIAL_WRITE;
		  //Se requiere solicitar datos del FIFO		     
		  nxt_curr_tx_buf_dout_in  = tx_buf_dout_in;
		  //Habilitar la lectura del FIFO Tx
		  tx_buf_rd_enb 	   = (curr_block_cnt-1 > 0) ? 1 : 0;
		  nxt_curr_block_sz 	   = curr_block_sz-4;
		  
		  if(new_block) begin //nuevo bloque (Secuencia de inicio)
		     nxt_new_block 	= 0;
		     nxt_DAT_dout_oe 	= 1;        //Enable DAT output (WRITE transaction)
		     nxt_DAT_dout 	= 4'b0000;  //Start Sequence
		  end
		  else begin //no un nuevo bloque (Secuencia intermedia)
		     nxt_sel_offset  = sel_offset+1;
		     //First 4 bit data group
		     nxt_DAT_dout    = nxt_curr_tx_buf_dout_in[(`FIFO_WIDTH-1)-:4]; 
		  end
	       end
	       else begin //El FIFO Tx está vacío por lo que se reintenta la escritura 
		  nxt_state 		   = NEW_WRITE;
		  nxt_curr_tx_buf_dout_in  = curr_tx_buf_dout_in;
		  nxt_DAT_dout_oe 	   = 0;   //Se deshabilita la salida de DAT
	       end
	    end
	 end

	 SERIAL_WRITE: begin
	    /*Se utiliza sel_offset como puntero para tomar segmentos de 4 bits de escritura
	    hacia la tarjeta SD*/
	    nxt_DAT_dout 	     = curr_tx_buf_dout_in[(`FIFO_WIDTH-1-(sel_offset<<2))-:4];
	    nxt_sel_offset 	     = (sel_offset < `FIFO_WIDTH/4-1) ? sel_offset+1 : 0;
	    nxt_curr_block_sz 	     = (curr_block_sz > 0) ? curr_block_sz-4 : 0;
	    nxt_curr_tx_buf_dout_in  = curr_tx_buf_dout_in;
	    
	    if(curr_block_sz == 0) begin //Se terminar de transmitir el bloque actual
	       nxt_state 	      = END_BLK_WRITE; //Secuencia de finalización de bloque
	       nxt_end_blk_write_cnt  = 3; //(CRC_seq_length = 2) + (END_seq_length = 1)
	       nxt_curr_block_cnt     = curr_block_cnt-1;
	    end
	    else begin
	       nxt_curr_block_cnt  = curr_block_cnt;
	       if(sel_offset < `FIFO_WIDTH/4-1) begin
		  nxt_state = SERIAL_WRITE;
	       end
	       else begin		  
		  if (sel_offset == `FIFO_WIDTH/4-1) begin
		     nxt_state = NEW_WRITE; //Nueva lectura del FIFO Tx para la escritura a DAT
		  end
		  else begin //Caso por defecto no esperado
		     nxt_state = IDLE;
		  end
	       end	
	    end
	 end

	 END_BLK_WRITE: begin
	    nxt_curr_block_cnt 	= curr_block_cnt;
	    nxt_curr_block_sz 	= curr_block_sz;

	    //----------Secuencia de CRC y finalización---------------
	    if(end_blk_write_cnt > 1) begin
	       nxt_end_blk_write_cnt  = end_blk_write_cnt-1;
	       nxt_state 	      = END_BLK_WRITE;
	       nxt_DAT_dout 	      = 4'h0; //Secuencia CRC
	    end
	    else begin
	       if(end_blk_write_cnt == 1) begin
		  nxt_end_blk_write_cnt  = end_blk_write_cnt-1;
		  nxt_state 		 = END_BLK_WRITE;
		  nxt_DAT_dout 		 = 4'b1111; //Secuencia de finalización
	       end
	       else begin //end_blk_write_cnt == 0
		  nxt_DAT_dout_oe  = 0; //Se deshabilita la escritura a DAT
		  nxt_DAT_dout 	   = 0; //La salida de DAT es 0 por defecto
		  if(curr_block_cnt > 0) begin //Se requiere transmitir más bloques (tramas)
		     //Ir a NEW_WRITE para transmitir un nuevo bloque (Secuencia de inicio)
		     nxt_state 		= NEW_WRITE;                        
		     nxt_new_block 	= 1;
		     nxt_curr_block_sz 	= block_sz;
		  end
		  else begin //Se termina la transferencia de bloques
		     nxt_state 	  = IDLE;
		     tf_finished  = 1;
		  end
	       end		  
	    end
	 end
//------------------------------ Transacción READ -----------------------------
	 NEW_READ: begin
	    nxt_curr_block_cnt 	= curr_block_cnt;
	    nxt_curr_block_sz 	= curr_block_sz;

	    if(new_block && DAT_din!=4'b0000) begin //Secuencia de inicio no recibida todavía
	       nxt_state      = NEW_READ;
	       nxt_new_block  = 1; //Se reintenta la operación de lectura
	    end
	    else begin
	       //----------Secuencia de inicio o intermedia de un bloque----------
	       nxt_state  = SERIAL_READ;
	       if(read_flag) begin
		  nxt_curr_block_sz  = curr_block_sz-4;
		  if(new_block) begin  //Nuevo bloque (Secuencia de inicio)
		     nxt_new_block 	      = 0;
		     nxt_rx_buf_din_out  = 0;
		  end
		  else begin  //No un nuevo bloque (Secuencia intermedia)
		     nxt_sel_offset 	      = sel_offset+1;
		     //Primer segmento de 4 bits
		     nxt_rx_buf_din_out  = DAT_din << (`FIFO_WIDTH-4);
		  end
	       end
	       else begin //FIFO Rx está lleno
		  nxt_state 	      = NEW_READ;
		  nxt_rx_buf_din_out  = rx_buf_din_out;
	       end
	    end
	 end

	 SERIAL_READ: begin
	    /*Se utiliza sel_offset como puntero para tomar segmentos de 4 bits de la tarjeta SD
	     y colocarlos consecutivamente en el bloque de 32 bits que se escribe en FIFO Rx*/
	    
	    nxt_rx_buf_din_out 	= rx_buf_din_out | (DAT_din << (`FIFO_WIDTH-4-(sel_offset << 2)));
	    nxt_sel_offset 	= (sel_offset < `FIFO_WIDTH/4-1) ? sel_offset+1 : 0;
	    nxt_curr_block_sz 	= (curr_block_sz > 0) ? curr_block_sz-4 : 0;
	    if(curr_block_sz == 0) begin //Se termina de recibir el bloque actual
	       nxt_state 	       = END_BLK_READ;
	       nxt_curr_block_cnt      = curr_block_cnt-1;
	       nxt_rx_buf_wr_enb  = 1;
	    end
	    else begin
	       nxt_curr_block_cnt  = curr_block_cnt;
	       if(sel_offset < `FIFO_WIDTH/4-1) begin
		  nxt_state  = SERIAL_READ;
	       end
	       else begin		  
		  if (sel_offset == `FIFO_WIDTH/4-1) begin
		     nxt_state 		     = NEW_READ;
		     nxt_rx_buf_wr_enb  = 1;
		  end
		  else begin //Caso por defecto no esperado
		     nxt_state = IDLE;
		  end
	       end	
	    end
	 end

	 END_BLK_READ: begin
	    nxt_curr_block_cnt 	= curr_block_cnt;
	    nxt_curr_block_sz 	= curr_block_sz;

	    //----------Secuencia de CRC y finalización---------------
	    if(DAT_din!=4'b1111) begin //Señal de finalización (tarjeta SD) no recibida aún
	       nxt_state  = END_BLK_READ;
	       //Se simula entonces la recepción de la secuencia CRC
	    end
	    else begin
	       if(curr_block_cnt > 0) begin //Se necesita leer más bloques
		  //Ir a NEW_READ para leer un nuevo bloque
		  nxt_state 	     = NEW_READ;
		  nxt_new_block      = 1;
		  nxt_curr_block_sz  = block_sz;
	       end
	       else begin //Se termina la lectura de bloques 
		  nxt_state    = IDLE;
		  tf_finished  = 1;
	       end
	    end
	 end
	 
	 default:
	    nxt_state = IDLE;
      endcase

   end
   
endmodule
