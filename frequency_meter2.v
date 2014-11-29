`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: makkosik
// 
// Create Date:    16:49:27 03/04/2012 
// Design Name: 
// Module Name:    frequency_meter 
// Project Name: 
// Description:    Freq Meter (by pps)
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module frequency_meter2 #(parameter BASE = 0) (
	 input wire pps,
	 input wire in,
	 
    // IO
    input [7:0] port_id,
	 output [7:0] in_port,
    input read_strobe
);

reg [31:0] cnt;
reg [31:0] scnt;
/*
always @ (posedge pps)
begin
  cnt <= 0;
  scnt <= cnt;
end 

always @ (posedge in)
begin
  cnt <= cnt + 1;
end*/

always @ (posedge pps, posedge in)
begin
  if (pps == 1'b1)
  begin
    cnt <= 0;
	 scnt <= cnt;
  end else begin
    cnt <= cnt + 1;
  end
end

// read
assign in_port = 
 (port_id == BASE + 3) ? scnt[7:0] : 
((port_id == BASE + 2) ? scnt[15:8] : 
((port_id == BASE + 1) ? scnt[23:16] : 
((port_id == BASE + 0) ? scnt[31:24] : 8'bz)));

endmodule
