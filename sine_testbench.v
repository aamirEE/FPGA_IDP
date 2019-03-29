`timescale 1 ns/100 ps

module cordic_test;

localparam  SZ = 16; // bits of accuracy

//reg  [3:0] Xin, Yin;
reg    [31:0] angle;
wire [SZ-1:0] Xout, Yout;  // Since, Xin which we are giving already account for shrinkage by same expansion factor.
reg         CLK_100MHZ;

//
// Waveform generator
//

// fixed point data-format Xout (signed) Q1.14

//localparam VALUE = 15; // 2^(14) / 1.647

CORDIC uut(
  .CLK_100MHZ(CLK_100MHZ),
  .angle(angle),
//  .Xin(Xin), 
//  .Yin(Yin),
  .Xout(Xout), 
  .Yout(Yout)
);
  
initial
begin
 // $dumpvars(1,cordic_test);
   CLK_100MHZ = 1'b1;
	//Xin = VALUE;                     
   //Yin = 1'd0;
	angle = 32'b01101010101010101010101010101011; // 150 degree
	//angle = 32'b00010101010101010101010101010101; // 30 degree
	//angle = 32'b10101010101010101010101010101011; // 240 degree
	//angle = 32'b11101010101010101010101010101011; // 330 degree
	//angle = 32'b11101010101010101010101010101011; // -30 degree
	//angle = 32'b00011000111000111000111000111000; // 35 degree
	//angle = 32'b11100111000111000111000111001000; // -35 degree
	//angle = 32'b11100111000111000111000111000111; // 325 degree
   //angle = 32'b01000000000000000000000000000000; // 90 degree

	
end
 
  always #5 CLK_100MHZ = ~CLK_100MHZ;
  
endmodule

