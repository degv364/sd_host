//Modulo que realiza la transferencia de datos

module transfer(input start,
		input  direction,
		output TFC,
		input [63:0]  address_init,
		input  [15:0] length,
		output ram_read,
		output ram_write,
		output fifo_read,
		output fifo_write,
		input  [31:0] data_from_ram,
		output [31:0] data_to_ram,
		input  [31:0] data_from_fifo,
		output [31:0] data_to_fifo,
		output [63:0] ram_address,
		input  fifo_empty,
		input fifo_full,
		input  CLK);

   
   //direction: 1-> ram to fifo
   //direction: 0-> fifo to ram
   reg	       TFC;
   reg 	       ram_read;
   reg 	       ram_write;
   reg 	       fifo_read;
   reg 	       fifo_write;
   reg 	       data_to_ram;
   reg 	       data_to_fifo;
   reg 	       ram_address;
   

   //when transmission is completed, TFC is 1
   //state machine changes state and makes start=0,
   //so comunication is ended from outside.
   always @(posedge CLK) begin
      if (start==0) begin
	 //no transmission
	 ram_write=0;
	 ram_read=0;
	 fifo_read=0;
	 fifo_write=0;
	 TFC=1;
	 data_to_ram=0;
	 data_to_fifo=0;
	 ram_address=address_init;
      end // if (start==0)
      else begin
	 TFC=0;
	 
	 //trnasmission
	 if (direction==1) begin
	    if (fifo_full==1) begin
	       TFC=1;
	       ram_read=0;
	       ram_write=0;
	       fifo_read=0;
	       fifo_write=0;
	       ram_address=address_init;
	       
	    end
	    else begin
	       //read from ram, write to fifo
	       ram_read=1;
	       ram_write=0;
	       fifo_read=0;
	       fifo_write=1;
	       //transfer data and update address
	       data_to_fifo=data_from_ram;
	       data_to_ram=0;
	       
	       ram_address=ram_address+4;
	       
	    end // else: !if(fifo_full==1)
	 end // if (direcion==1)
	 else begin //direction ==0
	    if (fifo_empty==1) begin
	       TFC=1;
	       ram_read=0;
	       ram_write=0;
	       fifo_read=0;
	       fifo_write=0;
	       ram_address=address_init;
	    end
	    else begin
	       // read from  fifo, write to ram
	       ram_read=0;
	       ram_write=1;
	       fifo_read=1;
	       fifo_write=0;
	       //transfer data and update address
	       data_to_ram=data_from_fifo;
	       data_to_fifo=0;
	       ram_address=ram_address+4;
	       
	    end // else: !if(fifo_empty==1)
	 end // else: !if(direcion==1)

	 //Logic for transfer complete
	 if (ram_address==(address_init+length)) begin
	    //transfer is complete
	    TFC=1;
	 end
	 else begin
	    TFC=TFC;
	 end
	 
      end // else: !if(start==0)
   end // always @ (posedge CLK)
endmodule // transfer

	       
	       
