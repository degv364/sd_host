`include "definitions.v"

module verificador(bandera_de_error, cuenta_comportamiento, cuenta_estructural);
   //se encarga de verificar que la salida de ambos contadores se la misma.
   //al detectar un error detiene la simulacion, pero da la opcion de continuar. 
   input [31:0] cuenta_comportamiento;
   input [31:0] cuenta_estructural;
   
   output 	bandera_de_error;
   reg 		bandera_de_error;
   

   always @( cuenta_estructural) begin
      if (cuenta_comportamiento==cuenta_estructural) begin
	 bandera_de_error=0;
      end else begin
	 bandera_de_error=1;
	 $display  ("Hay un error en la salida. \n digite >cont< para continuar, o >finish< para finalizar la simulacion \n %d %d", cuenta_comportamiento, cuenta_estructural);
	 #0 $stop;
	 
      end
      
   end
   
endmodule // verificador
