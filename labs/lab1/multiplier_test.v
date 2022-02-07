`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:16:46 02/04/2022
// Design Name:   multiplier
// Module Name:   C:/Users/c200201/Desktop/CZ3001_Lab1/CZ3001_Lab1/multiplier_test.v
// Project Name:  CZ3001_Lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: multiplier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module multiplier_test;

	// Inputs
	reg [63:0] a;
	reg [63:0] b;

	// Outputs
	wire [63:0] out;

	// Instantiate the Unit Under Test (UUT)
	multiplier uut (
		.a(a), 
		.b(b), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#200 a = 64'h02; // after 200ns make a=2;
		#200 b = 64'h05; // after 200ns make b=5;

	end
      
endmodule

