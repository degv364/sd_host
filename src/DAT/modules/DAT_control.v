////////////////////////////////////////////////////////
// Module: DAT_control
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`timescale 1ns/10ps
/*
Módulo de control para el bloque DAT. Este módulo opera a la frecuencia del Host, y utiliza
 la información del Transfer Mode Register y una señal de inicio proveniente del bloque CMD 
 (respuesta recibida) para indicar el comienzo de una operación de lectura o escritura.
 
 Este se encarga de inicializar el bloque de la capa física para que comience la transmisión,
 además de esperar hasta la finalización de la transación correspondiente. 
 
 Por otro lado, se encarga de la escritura de ciertas banderas en los registros, tales como 
 Command Inhibit (DAT), Transfer Complete (Normal Interrupt Status), entre otras.
*/
module DAT_control (
		    input  host_clk, //Reloj del Host
		    input  rst_L, //Reset 
		    input  tf_direction_reg, //Bit de dirección (Transfer Mode Reg)
		    input  resp_recv,        //Respuesta recibida de CMD
		    input  tx_buf_empty,     //FIFO Tx vacío
		    input  rx_buf_full,      //FIFO Rx lleno
		    input  tf_finished,      //Se termina la transferencia (de DAT_Phys)
		    input  dat_phys_busy,    //DAT_Phys está ocupado
		    output wr_tf_active_reg, //Bit de escritura activa (Present State Reg)
		    output rd_tf_active_reg, //Bit de lectura activa (Present State Reg)
		    output cmd_inhibit_dat_reg, //Inhabilitación de comandos de DAT (Present State)
		    output [2:0] PSR_wr_enb, //Habilitación de escritura en el Present State Reg
		    output tf_complete_reg, //Bit de transferencia completa (Normal Interrupt Reg)
		    output NISR_wr_enb,     //Habilitación de escritura en el Normal Interrupt Reg
		    output dat_wr_flag,     //Indicar a la capa física escritura
		    output dat_rd_flag      //Indicar la capa física lectura
		    );
   //Regs
   //Salidas
   reg 			   dat_wr_flag;
   reg 			   dat_rd_flag;
   reg 			   wr_tf_active_reg;
   reg 			   rd_tf_active_reg;
   reg 			   cmd_inhibit_dat_reg;
   reg [2:0] 		   PSR_wr_enb;
   reg 			   tf_complete_reg;
   reg 			   NISR_wr_enb;
   
   
   parameter SIZE = 5;
   reg [SIZE-1:0] 	   state;
   reg [SIZE-1:0] 	   nxt_state;
   
   //Estados FSM
   parameter IDLE = 5'b00001;
   parameter WRITE_START = 5'b00010;
   parameter READ_START = 5'b00100;
   parameter READ_TRANSFER  = 5'b01000;
   parameter WRITE_TRANSFER  = 5'b10000;

   wire 		   wr_valid;
   wire 		   rd_valid;

   assign wr_valid  = !tx_buf_empty && !dat_phys_busy;
   assign rd_valid = !rx_buf_full && !dat_phys_busy;

   
   //Actualización del estado 
   always @ (posedge host_clk) begin
      if(!rst_L) begin
	 state <= IDLE;
      end	
      else
	 state <= nxt_state;
   end

   //Lógica del próximo estado y de salidas
   always @(*) begin
      //Valores de salidas por defecto
      dat_wr_flag 	   = 0;
      dat_rd_flag 	   = 0;
      wr_tf_active_reg 	   = 0;
      rd_tf_active_reg 	   = 0;
      cmd_inhibit_dat_reg  = 0;
      tf_complete_reg 	   = 0;
      PSR_wr_enb 	   = 0;
      NISR_wr_enb 	   = 0;
      
      case (state)
	 //Estado de espera
	 IDLE: begin
	    if(resp_recv) begin
	       if(tf_direction_reg == 1) begin //Lectura
		  nxt_state = READ_START;
	       end
	       else begin //Escritura
		  nxt_state = WRITE_START;
	       end
	    end
	    else begin
	       nxt_state = IDLE;
	    end
	 end 
	 //Inicialización de la transacción de escritura
	 WRITE_START: begin
	    if(wr_valid) begin
	       nxt_state 	    = WRITE_TRANSFER;
	       dat_wr_flag 	    = 1; //Se le indica a la capa física que comience una escritura
	       wr_tf_active_reg     = 1;
	       PSR_wr_enb[1] 	    = 1;
	       cmd_inhibit_dat_reg  = 1;
	       PSR_wr_enb[0] 	    = 1;
	    end
	    else
	       nxt_state = WRITE_START;
	 end	

	 //Inicialización de la transacción de lectura
	 READ_START: begin
	    if(rd_valid) begin
	       nxt_state 	    = READ_TRANSFER;
	       dat_rd_flag 	    = 1;  //Se le indica a la capa física que comience una lectura
	       rd_tf_active_reg     = 1;
	       PSR_wr_enb[2] 	    = 1;
	       cmd_inhibit_dat_reg  = 1;
	       PSR_wr_enb[0] 	    = 1;
	    end
	    else
	       nxt_state = READ_START;
	 end

	 //Ejecución de la transacción de lectura
	 READ_TRANSFER: begin
	    if(!tf_finished) begin
	       dat_rd_flag  = !rx_buf_full;
	       nxt_state    = READ_TRANSFER;
	    end
	    else begin //Se recibe la señal de finalización desde la capa física
	       rd_tf_active_reg     = 0;
	       PSR_wr_enb[2] 	    = 1;
	       cmd_inhibit_dat_reg  = 0;
	       PSR_wr_enb[0] 	    = 1;
	       tf_complete_reg 	    = 1;
	       NISR_wr_enb 	    = 1;
	       nxt_state 	    = IDLE;
	    end
	 end

	 //Ejecución de la transacción de escritura
	 WRITE_TRANSFER: begin
	    if(!tf_finished) begin
	       dat_wr_flag = !tx_buf_empty;
	       nxt_state = WRITE_TRANSFER;
	    end	
	    else begin  //Se recibe la señal de finalización desde la capa física
	       wr_tf_active_reg     = 0;
	       PSR_wr_enb[1] 	    = 1;
	       cmd_inhibit_dat_reg  = 0;
	       PSR_wr_enb[0] 	    = 1;
	       tf_complete_reg 	    = 1;
	       NISR_wr_enb 	    = 1;
	       nxt_state 	    = IDLE;
	    end
	 end
 
	 default: begin
	    nxt_state = IDLE;
	 end
      endcase
   end  
endmodule
