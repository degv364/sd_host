`include "definitions.v"
`include "counters/counter_4_bit.v"
`include "counters/signals_4_bit.v"
`include "counters/counter_cnd.v"


module test;
   wire       ENABLE;
   wire [1:0] MODO;
   wire [3:0] CARGA;
   wire [3:0] CUENTA;
   wire       RCO;
   wire       CLK;

   wire [3:0] CUENTA2;
   wire       RCO2;
   

   signal s1 (ENABLE, MODO, CARGA, CLK); //instancia del modulo generador de senales
   

   counter_4_bit c1 (.CUENTA(CUENTA), .RCO(RCO), .CLK(CLK), .MODO(MODO), .ENABLE(ENABLE), .CARGA(CARGA)); //instancia del contador

   counter c_conductual(.CUENTA(CUENTA2), .RCO(RCO2), .CLK(CLK), .MODO(MODO), .ENABLE(ENABLE), .CARGA(CARGA));
   

   
   initial
     $monitor("At time %t, CUENTA = %h (%0d)",
              $time, CUENTA, CUENTA);
   
endmodule // test
