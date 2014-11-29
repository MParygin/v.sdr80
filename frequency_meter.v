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
module frequency_meter #(parameter BASE = 0) (
    input wire clk,
	 input wire pps,
	 input wire in,
	 
    // IO
    input [7:0] port_id,
	 output [7:0] in_port,
    input read_strobe
);

reg [31:0] cnt;
reg [31:0] scnt;
reg old;

// double buffer sync
reg in1;
reg in2;

always @ (posedge clk)
begin
  if (pps == 1'b1)
  begin
    cnt <= 0;
	 scnt <= cnt;
  end else begin
    if (old != in2)
	 begin
	   if (old == 1'b0)
		begin
        cnt <= cnt + 1;
		end  
	   old <= in;
	 end
  end
  
  // sync
  in1 <= in;
  in2 <= in1;
end

// read
assign in_port = 
 (port_id == BASE + 3) ? scnt[7:0] : 
((port_id == BASE + 2) ? scnt[15:8] : 
((port_id == BASE + 1) ? scnt[23:16] : 
((port_id == BASE + 0) ? scnt[31:24] : 8'bz)));

endmodule
