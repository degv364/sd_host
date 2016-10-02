`include "definitions.v"
`ifndef COUNTER_4_BITS
`define COUNTER_4_BITS
module counter(CUENTA, RCO, CARGA, ENABLE, MODO, CLK);
   
   output [3:0] CUENTA; //salida del contador
   output 	RCO; //carry out
   
   input 	CLK, ENABLE; //reloj, y habilitacion
   input [1:0] 	MODO; //MODO de operacion
   input [3:0] 	CARGA; // valor del numero que se carga en paralelo
   

   reg [3:0] 	CUENTA;
   reg 		RCO;
   
   wire 	CLK, ENABLE;
   wire [1:0] 	MODO;
   wire [3:0] 	CARGA;
   
   always @(posedge CLK) begin
     
      if (ENABLE) begin
	 if (MODO==00) begin
	    //contador 1 a 1 
	    CUENTA = CUENTA+1;
	 end
   
	 if (MODO==01) begin
	    //contador hacia atras
	    CUENTA = CUENTA-1;
	 end
   
	 if (MODO==2) begin
	    //contador hacia atras 3 en 3
	    CUENTA = CUENTA-3;
	 end
    
      
	 if (MODO==3) begin
	    //carga en paralelo
	       CUENTA = CARGA;
	 end
      end // if (ENABLE)
   end // always @ (posedge CLK)
 

   always @(*) begin
      if (ENABLE==1) begin
	 if (MODO==0)begin
	     if (CUENTA==15)
	       RCO=1;
	     else
	       RCO=0;   
	 end
	 else if (MODO==1)begin
	    if (CUENTA==0)
	      RCO=1;
	    else
	      RCO=0;
	 end
	 else if (MODO==2)begin
	    if (CUENTA<3)
	      RCO=1;
	    else
	      RCO=0;
	 end
	 else begin
	   RCO=0;
	 end
	 
      end else begin // if (ENABLE==1)
	 RCO=0;
      end // else: !if(ENABLE==1)
   end // always @ (*)
   
	 
   
endmodule // counter

`endif //  `ifndef COUNTER_4_BITS
