`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: makkosik
// 
// Create Date:    18:17:27 02/26/2012 
// Module Name:    test_vco 
// Description:    Test NCO
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test_nco(
    input wire clk, 
	 output wire [23:0] wave
);

wire [11:0] ph;
nco #(.WIDTH(12),.PHASE(23)) nco (
    .clk(clk),
	 .inc(2237),
	 .out(ph)
); 

wire [16:0] sin;
sincos sc (
    .clk(clk),
	 .phase(ph),
	 .out_sin(sin),
	 .out_cos()
);

assign wave = {1'b00, ~sin[16], sin[15:0], 6'b0};

endmodule
