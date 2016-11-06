`include "fifo_signals.v"
`include "simple_fifo.v"

module test_fifo;

   wire [31:0] data_out_of_fifo;
   wire [31:0] data_in;
   wire        read;
   wire        write;

   wire        full;
   wire        empty;
   wire        CLK;

   simple_fifo simple_fifo(.data_in(data_in), .data_out(data_out_of_fifo), .write(write),.read(read), .full(full), .empty(empty),.CLK(CLK) );
   fifo_signal fifo_signal(.data_out(data_in), .write(write), .read(read), .CLK(CLK) );
   
endmodule // test_fifo

