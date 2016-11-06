
module fifo_signal(data_out, write, read, CLK);

   output [31:0] 	  data_out;
   
   output 		  write;
   
   output 		  read;
   
   output 		  CLK;
   
   
   reg [31:0] 	 data_out=0;
   reg 		 write=1;
   reg 		 read=0;
   
   reg 		 CLK=0;
      
   initial begin
      $dumpfile ("test_fifo.vcd");
      $dumpvars (0, test_fifo);
      //write data
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 data_out=data_out+1;
      # 1 write=0;
      # 1 read =1;
      
      # 12 $finish;
   end

   always #1 CLK = !CLK;

endmodule // signal_32
