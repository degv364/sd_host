`include "definitions.v"


module signal(ENABLE, MODO, CARGA, CLK);
   
   output       ENABLE;
   output [1:0] MODO;
   output [3:0] CARGA;
   output 	CLK;
   

   reg 		ENABLE = 1;
   reg [1:0] 	MODO = 3;
   reg [3:0] 	CARGA=0;
   //Escrito el cero inicial
   
   
   initial begin
      $dumpfile ("test.vcd");
      $dumpvars (0, test);
      //Conteo de 1 en 1
      //# 1 MODO=1;
      //# 2 MODO =2;
      
      # 8700 MODO =0;
      //Conteo hacia atras 1 en 1
      # 8700 MODO = 3;
      # 1740 CARGA=0;
      # 1740 MODO = 1;
      //Conteo hacia atras 3 en 3
      # 8700 MODO = 3;
      # 1740 CARGA=0;
      # 1740 MODO=2;
      //Pruebas en Dlelo
      # 8700 ENABLE = 0;
      # 1740 MODO = 3;
      # 1740 ENABLE = 1;
      # 1740 CARGA =7;
      # 1740 CARGA =5;
      # 4 $finish;
   end

   reg CLK = 0;
   always #870 CLK = !CLK;

endmodule // signal
