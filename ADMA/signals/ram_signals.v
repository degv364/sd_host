
module ram_signal(address, write, read, data_out, CLK);

   output [63:0] address;
   output [31:0] data_out;
   output 	 write;
   output 	 CLK;
   output 	 read;
   
   
   
   reg [63:0]	 address=0; 
   reg [31:0] 	 data_out=0;
   reg 		 write=1;
   reg 		 read=0;
   
   reg 		 CLK=1;
      
   initial begin
      $dumpfile ("test_ram.vcd");
      $dumpvars (0, test_ram);
      //conteo de 1 en 1
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;

      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;

      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      

      # 10 write = 0;
      # 0 read =1;
      
      
      # 2 address=512;
      

      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;

      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;

      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;
      # 2 address =address+4;
      # 0 data_out=data_out+4;

      # 5 $finish;
   end

   always #1 CLK = !CLK;

endmodule // signal_32
