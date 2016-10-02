`include "definitions.v"
`include "counters/counter_for_synth.v"
module counter_32_for_synth(Q,CLK, MODO, ENB, D);
   output [31:0] Q;

   input [1:0] 	 MODO;
   input 	 ENB, CLK;		
   input [31:0]  D;
   
   wire [31:0] 	 Q;
   wire [8:0] 	 RCOS;
   
   wire [1:0] 	 MODO;
   reg [1:0] 	 real_modo;
   wire 	 ENB, CLK;
   wire [31:0 ]  D;

   //Qput [7:0 ] changing;
   reg 	[7:0]	 changing; //variable D indicarle a un contador que puede cambiar de valor, un bit D cada contador, 8 en total
   always @(*) begin
      if (MODO==2) begin
	 real_modo=1;
      end else begin
	 real_modo=MODO;
      end
   end
   
   
   
   //se instancian los contadores de 4 bits, D formar el de 32 bits
   counter_for_synth c1 (.CUENTA(Q[3:0])  , 
			 .RCO(RCOS[0]), 
			 .CLK(CLK),      
			 .MODO(MODO), 
			 .ENABLE(changing[0]), 
			 .CARGA(D[3:0]));
   counter_for_synth c2 (.CUENTA(Q[7:4]  ), 
			 .RCO(RCOS[1]), 
			 .CLK(CLK), 
			 .MODO(real_modo), 
			 .ENABLE(changing[1]), 
			 .CARGA(D[7:4]));
   counter_for_synth c3 (.CUENTA(Q[11:8] ), 
			 .RCO(RCOS[2]), 
			 .CLK(CLK), 
			 .MODO(real_modo), 
			 .ENABLE(changing[2]), 
			 .CARGA(D[11:8]));
   counter_for_synth c4 (.CUENTA(Q[15:12]), 
			 .RCO(RCOS[3]), 
			 .CLK(CLK), 
			 .MODO(real_modo), 
			 .ENABLE(changing[3]),
			 .CARGA(D[15:12]));
   counter_for_synth c5 (.CUENTA(Q[19:16]), 
			 .RCO(RCOS[4]), 
			 .CLK(CLK), 
			 .MODO(real_modo), 
			 .ENABLE(changing[4]), 
			 .CARGA(D[19:16]));
   counter_for_synth c6 (.CUENTA(Q[23:20]), 
			 .RCO(RCOS[5]), 
			 .CLK(CLK), 
			 .MODO(real_modo), 
			 .ENABLE(changing[5]), 
			 .CARGA(D[23:20]));
   counter_for_synth c7 (.CUENTA(Q[27:24]), 
			 .RCO(RCOS[6]), 
			 .CLK(CLK), 
			 .MODO(real_modo), 
			 .ENABLE(changing[6]), 
			 .CARGA(D[27:24]));
   counter_for_synth c8 (.CUENTA(Q[31:28]), 
			 .RCO(RCOS[7]), 
			 .CLK(CLK), 
			 .MODO(real_modo), 
			 .ENABLE(changing[7]), 
			 .CARGA(D[31:28]));
   
   //hay quie revisar el real_modo de operacion, D identificar como se manejan los enables de los contadores pequenos
   always @(*) begin   
      if (MODO==3) begin 
	 changing[0]=ENB;
	 changing[1]=ENB;
	 changing[2]=ENB;
	 changing[3]=ENB;
	 changing[4]=ENB;
	 changing[5]=ENB;
	 changing[6]=ENB;
	 changing[7]=ENB;
      end
      else begin
	 //habilite cambio si el contador de 32 bits esta habilitado, y si el contador en un bit menos significativo llego a un limite
	 changing[0]=ENB;
	 changing[1]=ENB & RCOS[0];
	 changing[2]=ENB & RCOS[1];
	 changing[3]=ENB & RCOS[2];
	 changing[4]=ENB & RCOS[3];
	 changing[5]=ENB & RCOS[4];
	 changing[6]=ENB & RCOS[5];
	 changing[7]=ENB & RCOS[6];
      end // else: !if(MODO==3)
   
   end

endmodule // counter_32

