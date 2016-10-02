`include "definitions.v"



module signal(ENABLE, MODO, CARGA, CLK);

   output        ENABLE; //habilitar cambios
   output [1:0]  MODO; //MODO de operacion
   output [31:0] CARGA; //numero que se carga en paralelo
   output 	 CLK; //reloj
   
   reg 		 ENABLE = 1; 
   reg [1:0] 	 MODO = 3;
   reg [31:0] 	 CARGA='hFFFFFFFF;
   
   
   initial begin
      $dumpfile ("test_potencia.vcd");
      $dumpvars (0, test);
      //conteo de 1 en 1
      # 1 MODO =0;
      # 8195 $stop;
      //conteo hacia atras 1 en 1
      # 0 MODO = 3;
      # 0 CARGA = 0;
      # 4 MODO = 1;
      # 8193 $stop;
      //Conteo 3 3n 3 hacia atras
      # 2 MODO = 2;
      # 8192 $stop;
      //Carga paralelo
      # 0 $finish;
   end

   reg CLK = 0;
   always #1 CLK = !CLK;

endmodule // signal_32

