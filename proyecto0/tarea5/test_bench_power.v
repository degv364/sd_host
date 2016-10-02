`include "definitions.v"
`include "counters/synth_power.v"
`include "counters/synth_power.v"
`include "counters/signal_potencia.v"
`include "verificador.v"

module test;
   wire ENABLE, CLK;
   wire [1:0] MODO;
   wire [31:0] CARGA;
   wire [31:0] CUENTA;

   wire [31:0] CUENTA_SYNTH;
   
   signal generator(.ENABLE(ENABLE), 
		    .MODO(MODO), 
		    .CARGA(CARGA), 
		    .CLK(CLK));

   counter_32_for_synth counter(.Q(CUENTA_SYNTH), 
				.CLK(CLK), 
				.MODO(MODO), 
				.ENB(ENABLE), 
				.D(CARGA));   


   integer     count;
   always @* begin
      count=counter.count;
   end

   initial begin
      $monitor("At time %t, Contador = %h (%0d) \n Conteo de conmutaciones= %d",$time, counter.Q, counter.Q, counter.count);
      
   end

   
endmodule // test

		
   
