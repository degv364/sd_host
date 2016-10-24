//includes

module state_machine(address_descriptor, RESET, STOP, CLK );
   
   input [95:0] address_descriptor;
   input 	RESET;
   input 	CLK;
   input 	STOP;
   
   
   
   reg [1:0] 	state;
   //there are 4 states, so
   //ST_STOP  00
   //ST_FDS   01
   //ST_CACDR 10
   //ST_TFR   11
   parameter ST_STOP = 0;
   parameter ST_FDS  = 1;
   parameter ST_CACDR= 2;
   parameter ST_TFR  = 3;


   //command related variables
   reg [63:0] 	address;
   reg [16:0] 	length;
   reg 		ACT1;
   reg 		ACT2;
   reg 		INT;
   reg 		END;
   reg 		VALID;
   
   assign address = address_descriptor[95:32];
   assign length  = address_descriptor[31:16];
   assign ACT1    = address_descriptor[5];
   assign ACT2    = address_descriptor[4];
   assign INT     = address_descriptor[2];
   assign END     = address_descriptor[1];
   assign VALID   = address_descriptor[0];
   
   assign NOP     = (~ACT2) & (~ACT1);
   assign RSV     = (~ACT2) & (ACT1);
   assign TRAN    = (ACT2) & (~ACT1);
   assign LINK    = (ACT2) & (ACT1);

   //internal variables
   reg 		TFC; //transfer data complete flag
   

   //state selector
   always @(posedge CLK) begin
      if (RESET) begin
	 state=ST_STOP;
      end else begin
	 case (state)
	   ST_STOP: begin 
	      //******TODO: implement command_reg************
	      if (command_reg_write | command_reg_continue) begin
		 state=ST_FDS;
	      end else begin
		 state=ST_STOP;
	      end
	   end
	   ST_FDS: begin
	      if (VALID==0) begin
		 state=ST_FDS;
	      end else begin
		 state=ST_CACDR;
	      end

	   end
	   ST_CADR: begin
	      if (TRAN==1) begin 
		 state = ST_TFR;
	      end else begin
		 if (END==1) begin
		    state = ST_STOP;
		 end else begin
		    state = ST_FDS;
		 end
	      end 
	   end 
	   ST_TFR: begin
	     
	      if (TFC==0) begin
		 state = ST_TFR;
	      end else begin
		 if (END==1 | STOP==1) begin
		    state= ST_STOP;
		 end else begin
		    state = ST_FDS;
		 end
	      end 
	   end 
	   default: begin
	      state=ST_STOP;
	   end
	 endcase // case (state)
      end // else: !if(RESET)
   end // always @ (posedge CLK)
   

   always @(state) begin
      case (state)
	ST_STOP: begin
	   //implementation
	end
	ST_FDS: begin
	   //implementation
	end
	ST_CACDR: begin
	   //implementation
	end
	ST_TFR: begin
	   //implementation
	end
	default: begin
	   //ST_STOP
	end
      endcase // case (state)
   end // always @ (state)

	 
     
