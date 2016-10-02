`include "definitions.v"

module signal_32(ENABLE, MODO, CARGA, CLK);
   output        ENABLE;
   output [1:0]  MODO;
   output [31:0] CARGA;
   output 	 CLK;

   reg 		 ENABLE =0;
   reg [1:0] 	 MODO;
   reg [31:0] 	 CARGA;

   initial begin
      $dumpfile ("test.vcd");
      $dumpvars (0, test);
      //conteo de 1 en 1
      # 1 ENABLE= 1;
      # 1 MODO=3;
      # 1 CARGA=0;
      # 3800 MODO =0;
      //conteo hacia atras 1 en 1
      //1730*33
      # 57090 MODO = 3;
      # 1730 CARGA = 0;
      # 1730 MODO = 1;
      //Conteo 3 3n 3 hacia atras
      # 57090 MODO = 3;
      # 1730 CARGA = 127;
      # 1730 MODO = 2;  
      //Carga paralelo
      # 74390 MODO=3;
      # 3460 ENABLE =0;
      # 3460 MODO=1;
      # 3460 MODO=3;
      # 3460 ENABLE=1;
      # 3460 CARGA=700;
      # 3460 CARGA=5000000;
      
      //# 27840 $finish;
      # 3460 $finish;
   end // initial begin

   reg CLK = 0;
   always #806 CLK = !CLK;
   //el periodo minimo es 1730. Eso significaria que el reloj
   //debe conmutar cada 865. se deja 870.   

endmodule // signal

