`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:16:27 03/04/2012 
// Design Name: 
// Module Name:    pps 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pps #(parameter DIV = 0)(
    input wire clk,
	 output reg strobe
);

reg [27:0] cnt;
always @ (posedge clk)
begin
  if (cnt == (DIV-1))
  begin
    cnt <= 0;
	 strobe <= 1;
  end else begin 
    cnt <= cnt + 1;
	 strobe <= 0;
  end
end

initial
begin
  cnt = 0;
end

endmodule
