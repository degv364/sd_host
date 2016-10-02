`include "definitions.v"
`include "counters/synth.v"
`include "counters/counter_32_cnd.v"
`include "counters/signal_32_nodelay.v"
`include "verificador.v"

module test;
   wire ENABLE, CLK;
   wire [1:0] MODO;
   wire [31:0] CARGA;
   wire [31:0] CUENTA;

   wire [31:0] CUENTA_SYNTH;
   
   
   
   verificador ver(.bandera_de_error(ERROR), 
		   .cuenta_comportamiento(CUENTA), 
		   .cuenta_estructural(CUENTA_SYNTH));
   
   signal_32 generator(.enable(ENABLE), 
		    .modo(MODO), 
		    .para(CARGA), 
		    .clk(CLK));

   counter_32_for_synth counter(.Q(CUENTA_SYNTH), 
				    .CLK(CLK), 
				    .MODO(MODO), 
				    .ENB(ENABLE), 
				    .D(CARGA));


   counter_32_cnd counter_conductual(.Q(CUENTA), 
				     .CLK(CLK),
				     .MODO(MODO), 
				     .ENB(ENABLE), 
				     .D(CARGA) );
   
  
   
   

`ifdef TEST
   integer     count;
   always @* begin
      count=counter.count;
   end

   initial begin
      $monitor("At time %t, Contador = %h (%0d) \n Conteo de conmutaciones= %d",$time, counter.OUT, counter.OUT, counter.count);
      
   end
`endif
   
endmodule // test

		
   
