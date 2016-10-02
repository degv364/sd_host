`include "definitions.v"

module signal_32(enable, modo, para, clk);

   output enable; //habilitar cambios
   output [1:0] modo; //modo de operacion
   output [31:0] para; //numero que se carga en paralelo
   output 	clk; //reloj
   
   reg 		     enable = 1; 
   reg [1:0] 	     modo = 3;
   reg [31:0]	     para=0;
   
   
   initial begin
      $dumpfile ("test.vcd");
      $dumpvars (0, test);
      //conteo de 1 en 1
      # 2 modo =0;
      //conteo hacia atras 1 en 1
      # 65536 modo = 3;
      # 0 para = 4294967296;
      # 0 $display("cuenta ascendente");
      
      # 2 modo = 1;
      //Conteo 3 3n 3 hacia atras
      # 65536 modo = 3;
      # 0 $display("cuenta descendente");
      # 2 para = 0;
      # 2 modo = 2;  
      //Carga paralelo
      # 65536 modo=3;
      # 1 enable =0;
      # 0 $display("cuenta descendente 3 en 3");
      # 1 modo=1;
      # 1 modo=3;
      # 1 enable=1;
      # 1 para=700;
      # 3 para=5000000;
      
      # 5 $stop;
   end

   reg clk = 0;
   always #1 clk = !clk;

endmodule // signal_32
