`timescale 1 ns/100 ps

module CORDIC (CLK_100MHZ,angle, Xout, Yout); // Xin,Yin
   
   parameter XY_SZ = 16;   // width of input and output data
   
   localparam STG = XY_SZ ; 
   
   input  CLK_100MHZ;
   input  signed         [31:0]   angle;
   //input  unsigned    [3:0]   Xin;
   //input  unsigned    [3:0]   Yin;
   output signed    [XY_SZ-1:0]   Xout;
   output signed    [XY_SZ-1:0]   Yout;
  
	//stage outputs
   reg signed [XY_SZ-1:0] X [0:STG-1];
   reg signed [XY_SZ-1:0] Y [0:STG-1];
   reg signed      [31:0] Z [0:STG-1]; // 32bit
   
   integer i = -1;
	
	//assign Xin = 9949;
	//assign Yin = 0;
	
   wire signed [31:0] atan_table [0:30];
   
   assign atan_table[00] = 32'b00100000000000000000000000000000; // 45.000 degrees -> atan(2^0)
   assign atan_table[01] = 32'b00010010111001000000010100011101; // 26.565 degrees -> atan(2^-1)
   assign atan_table[02] = 32'b00001001111110110011100001011011; // 14.036 degrees -> atan(2^-2)
   assign atan_table[03] = 32'b00000101000100010001000111010100; // atan(2^-3)
   assign atan_table[04] = 32'b00000010100010110000110101000011;
   assign atan_table[05] = 32'b00000001010001011101011111100001;
   assign atan_table[06] = 32'b00000000101000101111011000011110;
   assign atan_table[07] = 32'b00000000010100010111110001010101;
   assign atan_table[08] = 32'b00000000001010001011111001010011;
   assign atan_table[09] = 32'b00000000000101000101111100101110;
   assign atan_table[10] = 32'b00000000000010100010111110011000;
   assign atan_table[11] = 32'b00000000000001010001011111001100;
   assign atan_table[12] = 32'b00000000000000101000101111100110;
   assign atan_table[13] = 32'b00000000000000010100010111110011;
   assign atan_table[14] = 32'b00000000000000001010001011111001;
   assign atan_table[15] = 32'b00000000000000000101000101111101;
   assign atan_table[16] = 32'b00000000000000000010100010111110;
   assign atan_table[17] = 32'b00000000000000000001010001011111;
   assign atan_table[18] = 32'b00000000000000000000101000101111;
   assign atan_table[19] = 32'b00000000000000000000010100011000;
   assign atan_table[20] = 32'b00000000000000000000001010001100;
   assign atan_table[21] = 32'b00000000000000000000000101000110;
   assign atan_table[22] = 32'b00000000000000000000000010100011;
   assign atan_table[23] = 32'b00000000000000000000000001010001;
   assign atan_table[24] = 32'b00000000000000000000000000101000;
   assign atan_table[25] = 32'b00000000000000000000000000010100;
   assign atan_table[26] = 32'b00000000000000000000000000001010;
   assign atan_table[27] = 32'b00000000000000000000000000000101;
   assign atan_table[28] = 32'b00000000000000000000000000000010;
   assign atan_table[29] = 32'b00000000000000000000000000000001; // atan(2^-29)
   assign atan_table[30] = 32'b00000000000000000000000000000000;

  always @(posedge CLK_100MHZ)
   begin
	  if (i < 0)
		begin
			case (angle[31:30])
         2'b00,
         2'b11:   // no pre-rotation needed for these quadrants
         begin    // X[n], Y[n] is 1 bit larger than Xin, Yin, but Verilog handles the assignments properly
            X[0] <= 622;
            Y[0] <= 0;
            Z[0] <= angle;
         end
         
         2'b01:
         begin
            X[0] <= -0;
            Y[0] <= 622;
            Z[0] <= {2'b00,angle[29:0]}; // subtract pi/2 from angle for this quadrant
         end
         
         2'b10:
         begin
            X[0] <= 0;
            Y[0] <= -622;
            Z[0] <= {2'b11,angle[29:0]}; // add pi/2 to angle for this quadrant
         end
			endcase
		//$display("X[0] = %d",X[0]);
     //$display("i = %d ",i);
			i = 0;
//	  $display("i = %d ",i);
	  $display("X[0] = %d  at time = %t",X[0] , $time);
	  $display("Y[0] = %d ",Y[0]);
	  $display("Z[0] = %d ",Z[0]);
		end
	  else
		begin
		if(i < STG -1)
		begin
        // Z_sign = Z[i][31]; // Z_sign = 1 if Z[i] < 0
        
        X[i+1] = Z[i][31] ? X[i] + (Y[i] >>> i)         : X[i] - (Y[i] >>> i) ;
        Y[i+1] = Z[i][31] ? Y[i] - (X[i] >>> i)         : Y[i] + (X[i] >>> i) ;
        Z[i+1] = Z[i][31] ? Z[i] + atan_table[i] : Z[i] - atan_table[i];
		 $display("Z[%d][31] = %d at time = %t ",i,Z[i][31],$time);
		 $display("X[%d] = %d at time = %t ",i+1,X[i+1],$time);
	    $display("Y[%d] = %d at time = %t",i+1,Y[i+1],$time);
	    $display("Z[%d] = %d at time = %t",i+1,Z[i+1],$time);
		  i=i+1;
		end
		end
   end

   //------------------------------------------------------------------------------
   //                                 output
   //-----------------------------------------------------------------------------
	assign Xout = X[STG-1] >>> 5;
	assign Yout = Y[STG-1] >>> 5;
	
endmodule
