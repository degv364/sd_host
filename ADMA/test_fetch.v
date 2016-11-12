`include "modules/fetch.v"
`include "signals/fetch_signals.v"
`include "modules/ram.v"

module test_fetch;
   
   wire start;
   wire [63:0] address;
   wire [95:0] address_descriptor;
   wire [31:0] ram_data;
   wire [63:0] address_to_fetch;
   wire        CLK;
   wire        address_fetch_done;
   

   wire [31:0] data_in_to_ram;

   reg        read=1;
   wire        write;

   reg 	       start_internal;
   
   
   assign write=0;
   assign data_in_to_ram=0;
   
   
   fetch fetch(.start(start_internal),
	     .address(address),
	     .address_descriptor(address_descriptor),
	     .ram_data(ram_data),
	     .address_to_fetch(address_to_fetch),
	     .CLK(CLK),
	     .address_fetch_done(address_fetch_done));
   
   fetch_signal fetch_signal(.CLK(CLK),
			     .start(start),
			     .address(address));

   ram ram(.address(address_to_fetch),
	   .data_in(data_in_to_ram),
	   .write(write),
	   .read(read),
	   .CLK(CLK),
	   .data_out(ram_data));
   

   always @(*) begin
      if (address_fetch_done==1) begin
	 start_internal=0;
      end
      else begin
	 start_internal=start;
      end
   end
   
   
endmodule // test

