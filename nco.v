`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Maxim Parygin (mparygin@gmail.com)
// 
// Create Date:    23:15:50 02/15/2012 
// Design Name: 
// Module Name:    nco 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:    Numerical Controlled Oscillator
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module nco #(parameter WIDTH = 8, PHASE = 14)(
    input wire clk,
	 input wire [PHASE-1:0] inc,
	 output reg [WIDTH-1:0] out
);

// phase
reg [PHASE-1:0] phase;

always @ (posedge clk)
begin
  phase <= phase + inc;
  out[WIDTH-1:0] <= phase[PHASE-1:PHASE - WIDTH];
end


initial
begin
  phase = 0;
  out = 0;
end

endmodule
