////////////////////////////////////////////////////////
// Module: state_machine
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "../../defines.v"

//includes
`include "fetch.v"
`include "transfer.v"


//FIXME: PASAR esto a separacion de logica combinacional y flipflops

module state_machine(
		     input [63:0] starting_address,
		     input 	   RESET, 
		     input 	   STOP, 
		     input 	   CLK,
		     input [31:0]  data_from_ram,
		     input [31:0]  data_from_fifo,
		     input 	   fifo_full,
		     input 	   fifo_empty,
		     input 	   command_reg_write,
		     input 	   command_reg_continue,
		     input 	   direction, //1 -> ram to fifo
		     output [31:0] data_to_ram,
		     output [31:0] data_to_fifo,
		     output [63:0] ram_address,
		     output 	   ram_write,
		     output 	   ram_read,
		     output 	   fifo_write,
		     output 	   fifo_read,
		     output 	   start_transfer
		     );
   
   wire [95:0] 	fetch_address_descriptor;
   reg [95:0] 	address_descriptor;
   
   wire 	RESET;
   wire 	CLK;
   wire 	STOP;
   
   reg [5:0] 	state;

   //Estados en codificacion one hot
   parameter ST_STOP = 6'b000001;
   parameter ST_FDS_START= 6'b010000;
   parameter ST_FDS  = 6'b000010;
   parameter ST_CACDR= 6'b000100;
   parameter ST_TFR_START= 6'b100000;
   parameter ST_TFR  = 6'b001000;

   //command related variables
   wire [63:0] 	address;
   wire [15:0] 	length;
   wire 		ACT1;
   wire 		ACT2;
   wire 		INT;
   wire 		END;
   wire 		VALID;

   //Banderas internas
   assign address = address_descriptor[95:32];
   assign length  = address_descriptor[31:16];
   assign ACT1    = address_descriptor[5];
   assign ACT2    = address_descriptor[4];
   assign INT     = address_descriptor[2];
   assign END     = address_descriptor[1];
   assign VALID   = address_descriptor[0];

   //TODO: program NOP, RSV states
   assign NOP     = (~ACT2) & (~ACT1);
   assign RSV     = (~ACT2) & (ACT1);
   assign TRAN    = (ACT2) & (~ACT1);
   assign LINK    = (ACT2) & (ACT1);

   //read write flags
   reg 			ram_read;
   reg 			ram_write;
   reg 			fifo_read;
   reg 			fifo_write;
   wire 		ram_read_transfer;
   wire 		ram_write_transfer;
   wire 		fifo_read_transfer;
   wire 		fifo_write_transfer;
   


   
   //internal variables
   wire 		TFC; //transfer data complete flag
   reg [5:0] 		next_state;
   reg [63:0] 		ram_fetch_address;
   wire 		address_fetch_done;
   reg 			begin_fetch;
   reg [63:0] 		next_ram_address;
   reg 		start_transfer;
   wire [63:0]	ram_address_transfer;
   wire [63:0] 	ram_address_fetch;
   
   reg [63:0] 	ram_address;
   
   reg [32:0] 	counter;//counter for triggering signals
   wire 	start_confirmation;
   
   

   reg 		zero=0;

   
   //Parte secuencial
   always @(posedge CLK)begin
      if (RESET) begin
	 state=ST_STOP;
	 ram_address=0;
	 
	 //salidas nulas
      end
      else begin
	 state<=next_state;
	 //ram_address<=next_ram_address;
	 
	 //salida<=next_salida;
      end 
   end
   

   
   
   //state selector
   always @(*) begin
      if (RESET) begin
	 next_state=ST_STOP; //reset asincronico
      end else begin
	 case (state)
	   ST_STOP: begin 
	      if (command_reg_write==1 | command_reg_continue==1) begin
		 next_state=ST_FDS_START;
	      end else begin
		 next_state=ST_STOP;
	      end
	   end
	   
	   ST_FDS: begin
	      if (END==1)begin
		 next_state=ST_STOP;
	      end
	      else begin
		 if (VALID==0) begin
		    next_state=ST_FDS;
		 end 
		 else begin
		    if (address_fetch_done==1) begin
		       next_state=ST_CACDR;
		    end 
		    else begin
		       next_state=ST_FDS;
		    end
		 
		 end
	      end 
	      
	   end // case: ST_FDS
	   
	   ST_CACDR: begin
	      if (TRAN==1) begin 
		 next_state = ST_TFR_START;
	      end 
	      else begin
		 if (END==1) begin
		    next_state = ST_STOP;
		 end 
		 else begin
		    next_state = ST_FDS_START;
		 end
		 
	      end
 
	   end // else: !if(RESET)
	   
	   
	   
	   ST_TFR: begin
	     
	      if (TFC==0) begin
		 next_state = ST_TFR;
	      end else begin
		 if (END==1 | STOP==1) begin
		    next_state= ST_STOP;
		 end else begin
		    next_state = ST_FDS_START;
		 end
	      end 
	   end // always @ (*)
	   
	   ST_FDS_START: begin
	      next_state=ST_FDS;
	   end
	   
	   ST_TFR_START:begin
	      next_state=ST_TFR;
	   end
	   
	   default: begin
	      next_state=ST_STOP;
	   end
	 endcase // case (state)
      end // else: !if(RESET)
      
   end // always @ (*)
   
   
   //definicion de las salidas (entradas a bloques funcionales)
   always @(*) begin
      //next_ram_address=0;///avoid infferered latches
      case (state)
	ST_STOP: begin
	   //STOP DMA
	   //TFC=zero; //this is handled by transfer
	   //address_descriptor=0;
	   ram_read=0;
	   ram_write=0;
	   fifo_read=0;
	   fifo_write=0;
	   ram_fetch_address=starting_address;
	   begin_fetch=0;
	   start_transfer=0;
	   counter=0;
	   address_descriptor=0;
	   next_ram_address=0;
	   
	   
	end
	ST_FDS: begin
	   //Load address descriptor from memory
	   //requires 3 cycles to complete
	   begin_fetch=0;
	   
	   //begin_fetch=1;//Add new start confirmation
	   
	   start_transfer=0;
	   
	   ram_write=0;
	   ram_read=1; //habilitar lectura de ram
	   fifo_read=0;
	   fifo_write=0;
	   ram_address=ram_address_fetch;
	   address_descriptor=fetch_address_descriptor;
	   
	   
	end
	ST_CACDR: begin
	   //change reading address to fetch next cycle
	   begin_fetch=0;
	   start_transfer=0;
	   address_descriptor=address_descriptor;
	   
	   ram_address=next_ram_address;
	   if (LINK==1) begin
	      //read descriptor for new address
	      next_ram_address=address;
	   end
	   else begin
	      //next_ram_address=ram_address+4;
	      next_ram_address=ram_address+12; //address descriptor has 96 bits   
	   end
	   
	end
	ST_TFR: begin
	   start_transfer=0;
	   
	   //read write flags
	   if (start_transfer==1)begin
	      zero=1;
	   end
	   
	   ram_read=ram_read_transfer;
	   ram_write=ram_write_transfer;
	   fifo_read=fifo_read_transfer;
	   fifo_write=fifo_write_transfer;
	   address_descriptor=address_descriptor;
	   
	   
	   //Actually transfer the data.
	   begin_fetch=0;
	   //start_transfer=0;
	   ram_address=ram_address_transfer;
	   
	   //TODO fifo full, fifo empty
	   
	   
	end // case: ST_TFR
	ST_FDS_START: begin
	   begin_fetch=1;
	   address_descriptor=fetch_address_descriptor;
	   
	   
	   //begin_fetch=1;//Add new start confirmation
	   
	   start_transfer=0;
	   
	   ram_write=0;
	   ram_read=1; //habilitar lectura de ram
	   fifo_read=0;
	   fifo_write=0;
	   ram_address=next_ram_address;///MAY change
	   ram_fetch_address=next_ram_address;//May change
	   
	   
	   //ram_address=ram_address_fetch;
	end // case: ST_FDS_START
	ST_TFR_START: begin
	   //read write flags
	   ram_read=ram_read_transfer;
	   ram_write=ram_write_transfer;
	   fifo_read=fifo_read_transfer;
	   fifo_write=fifo_write_transfer;
	   address_descriptor=address_descriptor;
	   
	   
	   //Actually transfer the data.
	   begin_fetch=0;
	   start_transfer=1;
	   //ram_address=ram_address;
	   ram_address=ram_address_transfer;
	end // case: ST_TFR_START
	
	   
	default: begin
	   //ST_STOP
	   //TFC=zero; //this is handled by transfer
	   //address_descriptor=0;
	   ram_read=0;
	   ram_write=0;
	   fifo_read=0;
	   fifo_write=0;
	   ram_fetch_address=starting_address;
	   begin_fetch=0;
	   start_transfer=0;
	end
      endcase // case (state)
   end // always @ (state)

   //submodules
   fetch fetch(.start((begin_fetch & CLK)), //this signal is a trigger not an enable
	       .address(ram_fetch_address),
	       .address_fetch_done(address_fetch_done),
	       .address_descriptor(fetch_address_descriptor),
	       .ram_data(data_from_ram),
	       .address_to_fetch(ram_address_fetch),
	       .start_confirmation(start_confirmation),
	       .CLK(CLK));

   transfer transfer(.start((start_transfer & CLK)),
		     .direction(direction),
		     .TFC(TFC),
		     .address_init(address),
		     .length(length),
		     .ram_read(ram_read_transfer),
		     .ram_write(ram_write_transfer),
		     .fifo_read(fifo_read_transfer),
		     .fifo_write(fifo_write_transfer),
		     .data_from_ram(data_from_ram),
		     .data_to_ram(data_to_ram),
		     .data_from_fifo(data_from_fifo),
		     .data_to_fifo(data_to_fifo),
		     .ram_address(ram_address_transfer),
		     .fifo_full(fifo_full),
		     .fifo_empty(fifo_empty),
		     .CLK(CLK));
   


endmodule // state_machine

	 
     
