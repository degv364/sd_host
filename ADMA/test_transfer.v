`include "modules/transfer.v"
`include "signals/transfer_signals.v"
`include "modules/ram.v"
`include "modules/simple_fifo.v"

module test_transfer;

   wire start_transfer;
   wire direction;
   wire TFC;
   wire [63:0] address;
   wire [15:0] length;
   
   wire ram_read, ram_write, fifo_read, fifo_write;
   wire [31:0] data_from_ram;
   wire [31:0] data_to_ram;
   wire [31:0] data_from_fifo;
   wire [31:0] data_to_fifo;
   wire [63:0] ram_address;
   wire        fifo_full, fifo_empty;
   wire        CLK;
   
   
   
   transfer transfer(.start(start_transfer), //input
		     .direction(direction), //input
		     .TFC(TFC),
		     .address_init(address),//input
		     .length(length),//input
		     .ram_read(ram_read),
		     .ram_write(ram_write),
		     .fifo_read(fifo_read),
		     .fifo_write(fifo_write),
		     .data_from_ram(data_from_ram),//ram
		     .data_to_ram(data_to_ram),//ram
		     .data_from_fifo(data_from_fifo),//fifo
		     .data_to_fifo(data_to_fifo),//fifo
		     .ram_address(ram_address),//out_ram
		     .fifo_full(fifo_full),
		     .fifo_empty(fifo_empty),
		     .CLK(CLK));

   transfer_signal transfer_signal(.start(start_transfer),
				   .direction(direction),
				   .address_init(address),
				   .length(length),
				   .CLK(CLK));
   

   ram ram(.address(ram_address), //from transfer 
	   .write(ram_write), //from transfer
	   .read(ram_read), //from transfer
	   .data_in(data_ro_ram), //from transfer
	   .data_out(data_from_ram), //from transfer
	   .CLK(CLK));

   simple_fifo simple_fifo(.data_in(data_to_fifo), //from transfer
			   .data_out(data_from_fifo), //from transfer
			   .write(fifo_write), //from transfer
			   .read(fifo_read), //from transfer
			   .full(fifo_full), //from transfer
			   .empty(fifo_empty), //from transfer
			   .CLK(CLK));
endmodule // test_transfer

