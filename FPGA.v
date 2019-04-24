module CORDIC (input wire CLK_100MHZ,input signed wire[15:0] angle,output reg [7:0] Xout);//, Yout); // Xin,Yin
   
   parameter XY_SZ = 8;   // width of input and output data
   
   localparam STG = 8; 
   
   //input  CLK_100MHZ;
   //input  signed  [23:0]   angle;
   //output signed   [7:0]    Xout; 
  
	//stage outputs
   reg signed [XY_SZ-1:0] X [0:STG-1];
   reg signed [XY_SZ-1:0] Y [0:STG-1];
   reg signed      [15:0] Z [0:STG-1]; // 32bit
	
   wire signed [15:0] atan_table [0:13];
   
   assign atan_table[0]  =  16'b0010000000000000;
   assign atan_table[1]  =  16'b0001001011100100;
   assign atan_table[2]  =  16'b0000100111111011;
   assign atan_table[3]  =  16'b0000010100010001;
   assign atan_table[4]  =  16'b0000001010001011;
   assign atan_table[5]  =  16'b0000000101000101;
   assign atan_table[6]  =  16'b0000000010100010;
   assign atan_table[7]  =  16'b0000000001010001;
   assign atan_table[8]  =  16'b0000000000101000;
   assign atan_table[9]  =  16'b0000000000010100;
   //assign atan_table[10] =  16'b0000000000001010;
   //assign atan_table[11] =  16'b0000000000000101;
   //assign atan_table[12] =  16'b0000000000000010;
   //assign atan_table[13] =  16'b0000000000000001;

 always @(posedge CLK_100MHZ) // 19898*1.6467 = 32766: 32766 but extra one bit for sign 2^15 32768
   begin
	  //if (i < 0)
	//begin
	case (angle[15:14])
         2'b00,
         2'b11:   // no pre-rotation needed for these quadrants
         begin    // X[n], Y[n] is 1 bit larger than Xin, Yin, but Verilog handles the assignments properly
	//$display("angle = %d ",angle);
            X[0] = 75;
            Y[0] = 0;
            Z[0] = angle;
         end
         
         2'b01:
         begin
	//$display("angle = %d ",angle);
            X[0] = -0;
            Y[0] = 75;
            Z[0] = {2'b00,angle[13:0]}; // subtract pi/2 from angle for this quadrant
         end
         
         2'b10:
         begin
	//	$display("angle = %d ",angle);
            X[0] = 0;
            Y[0] = -75;
            Z[0] = {2'b11,angle[13:0]}; // add pi/2 to angle for this quadrant
         end
	endcase
	
        // Z_sign = Z[i][23]; // Z_sign = 1 if Z[i] < 0
        
        //i=0

        X[1] = Z[0][15] ? X[0] + (Y[0] >>> 0)         : X[0] - (Y[0] >>> 0) ;
        Y[1] = Z[0][15] ? Y[0] - (X[0] >>> 0)         : Y[0] + (X[0] >>> 0) ;
        Z[1] = Z[0][15] ? Z[0] + atan_table[0] : Z[0] - atan_table[0];

        //i=1

        X[2] = Z[1][15] ? X[1] + (Y[1] >>> 1)         : X[1] - (Y[1] >>> 1) ;
        Y[2] = Z[1][15] ? Y[1] - (X[1] >>> 1)         : Y[1] + (X[1] >>> 1) ;
        Z[2] = Z[1][15] ? Z[1] + atan_table[1] : Z[1] - atan_table[1];

         //i=2

        X[3] = Z[2][15] ? X[2] + (Y[2] >>> 2)         : X[2] - (Y[2] >>> 2) ;
        Y[3] = Z[2][15] ? Y[2] - (X[2] >>> 2)         : Y[2] + (X[2] >>> 2) ;
        Z[3] = Z[2][15] ? Z[2] + atan_table[2] : Z[2] - atan_table[2];

         //i=3

        X[4] = Z[3][15] ? X[3] + (Y[3] >>> 3)         : X[3] - (Y[3] >>> 3) ;
        Y[4] = Z[3][15] ? Y[3] - (X[3] >>> 3)         : Y[3] + (X[3] >>> 3) ;
        Z[4] = Z[3][15] ? Z[3] + atan_table[3] : Z[3] - atan_table[3];

         //i=4

        X[5] = Z[4][15] ? X[4] + (Y[4] >>> 4)         : X[4] - (Y[4] >>> 4) ;
        Y[5] = Z[4][15] ? Y[4] - (X[4] >>> 4)         : Y[4] + (X[4] >>> 4) ;
        Z[5] = Z[4][15] ? Z[4] + atan_table[4] : Z[4] - atan_table[4];

        //i=5

        X[6] = Z[5][15] ? X[5] + (Y[5] >>> 5)         : X[5] - (Y[5] >>> 5) ;
        Y[6] = Z[5][15] ? Y[5] - (X[5] >>> 5)         : Y[5] + (X[5] >>> 5) ;
        Z[6] = Z[5][15] ? Z[5] + atan_table[5] : Z[5] - atan_table[5];

         //i=6

        X[7] = Z[6][15] ? X[6] + (Y[6] >>> 6)         : X[6] - (Y[6] >>> 6) ;
        Y[7] = Z[6][15] ? Y[6] - (X[6] >>> 6)         : Y[6] + (X[6] >>> 6) ;
        Z[7] = Z[6][15] ? Z[6] + atan_table[6] : Z[6] - atan_table[6];
/*
         //i=7

        X[8] = Z[7][15] ? X[7] + (Y[7] >>> 7)         : X[7] - (Y[7] >>> 7) ;
        Y[8] = Z[7][15] ? Y[7] - (X[7] >>> 7)         : Y[7] + (X[7] >>> 7) ;
        Z[8] = Z[7][15] ? Z[7] + atan_table[7] : Z[7] - atan_table[7];

         //i=8

        X[9] = Z[8][15] ? X[8] + (Y[8] >>> 8)         : X[8] - (Y[8] >>> 8) ;
        Y[9] = Z[8][15] ? Y[8] - (X[8] >>> 8)         : Y[8] + (X[8] >>> 8) ;
        Z[9] = Z[8][15] ? Z[8] + atan_table[8] : Z[8] - atan_table[8];

         //i=9

        X[10] = Z[9][15] ? X[9] + (Y[9] >>> 9)         : X[9] - (Y[9] >>> 9) ;
        Y[10] = Z[9][15] ? Y[9] - (X[9] >>> 9)         : Y[9] + (X[9] >>> 9) ;
        Z[10] = Z[9][15] ? Z[9] + atan_table[9] : Z[9] - atan_table[9];

         //i=10

        X[11] = Z[10][23] ? X[10] + (Y[10] >>> 10)         : X[10] - (Y[10] >>> 10) ;
        Y[11] = Z[10][23] ? Y[10] - (X[10] >>> 10)         : Y[10] + (X[10] >>> 10) ;
        Z[11] = Z[10][23] ? Z[10] + atan_table[10] : Z[10] - atan_table[10];

         //i=11

        X[12] = Z[11][23] ? X[11] + (Y[11] >>> 11)         : X[11] - (Y[11] >>> 11) ;
        Y[12] = Z[11][23] ? Y[11] - (X[11] >>> 11)         : Y[11] + (X[11] >>> 11) ;
        Z[12] = Z[11][23] ? Z[11] + atan_table[11] : Z[11] - atan_table[11];

         //i=12

        X[13] = Z[12][23] ? X[12] + (Y[12] >>> 12)         : X[12] - (Y[12] >>> 12) ;
        Y[13] = Z[12][23] ? Y[12] - (X[12] >>> 12)         : Y[12] + (X[12] >>> 12) ;
        Z[13] = Z[12][23] ? Z[12] + atan_table[12] : Z[12] - atan_table[12];

         //i=13

        X[14] = Z[13][23] ? X[13] + (Y[13] >>> 13)         : X[13] - (Y[13] >>> 13) ;
        Y[14] = Z[13][23] ? Y[13] - (X[13] >>> 13)         : Y[13] + (X[13] >>> 13) ;
        Z[14] = Z[13][23] ? Z[13] + atan_table[13] : Z[13] - atan_table[13];

         //i=14

        X[15] = Z[14][23] ? X[14] + (Y[14] >>> 14)         : X[14] - (Y[14] >>> 14) ;
        Y[15] = Z[14][23] ? Y[14] - (X[14] >>> 14)         : Y[14] + (X[14] >>> 14) ;
        Z[15] = Z[14][23] ? Z[14] + atan_table[14] : Z[14] - atan_table[14];
*/
	Xout <= Y[7];
   end
	
   //------------------------------------------------------------------------------
   //                                 output
   //-----------------------------------------------------------------------------

	
endmodule
