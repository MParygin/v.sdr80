`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:22:10 03/04/2012 
// Design Name: 
// Module Name:    stats16 
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
module stats16 #(parameter BASE = 0)(
    input wire clk,
	 input wire pps,
	 input wire [15:0] data,

    // IO
    input [7:0] port_id,
	 output [7:0] in_port,
    input read_strobe
);

// data
reg [15:0] min;
reg [15:0] max;
reg [15:0] chg0;
reg [15:0] chg1;

// stats
reg [15:0] smin;
reg [15:0] smax;
reg [15:0] avg;

// main logic
always @ (posedge clk)
begin
  if (pps == 1'b1)
  begin
    // init
    min <= data;
	 max <= data;
	 chg0 <= data;
	 chg1 <= 0;
	 // stats
	 smin <= min;
	 smax <= max;
	 avg <= ({1'b0, min} + {1'b0, max}) >> 1;
  end else begin
    // collect
    min <= (data < min) ? data : min;
    max <= (data > max) ? data : max;
	 chg1 <= chg1 | (data ^ chg0);
  end
end

// read
assign in_port = 
 (port_id == BASE + 1) ? smin[7:0] : 
((port_id == BASE + 0) ? smin[15:8] : 
((port_id == BASE + 3) ? smax[7:0] : 
((port_id == BASE + 2) ? smax[15:8] : 
((port_id == BASE + 5) ? avg[7:0] : 
((port_id == BASE + 4) ? avg[15:8] : 
((port_id == BASE + 7) ? chg1[7:0] : 
((port_id == BASE + 6) ? chg1[15:8] : 8'bz)))))));


endmodule
