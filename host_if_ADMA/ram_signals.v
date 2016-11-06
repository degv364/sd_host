
module ram_signal(address, write, data_out, CLK);

   output [63:0] address;
   output [31:0] data_out;
   output 	 write;
   output 	 CLK;
   
   
   reg [63:0]	 address=512; 
   reg [31:0] 	 data_out=0;
   reg 		 write=1;
   reg 		 CLK=0;
      
   initial begin
      $dumpfile ("test.vcd");
      $dumpvars (0, test);
      //conteo de 1 en 1
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;

      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;

      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      

      # 5 write = 0;
      
      # 1 address=512;
      

      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;

      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;

      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;
      # 1 address =address+4;
      # 0 data_out=data_out+4;

      # 5 $finish;
   end

   always #1 CLK = !CLK;

endmodule // signal_32
