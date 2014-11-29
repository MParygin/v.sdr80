`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module vga_buffer #(parameter WIDTH = 0)(
  input wire clk,
  input wire in_hsync,
  input wire in_vsync,
  input wire [WIDTH-1:0] in_hdata,
  input wire [WIDTH-1:0] in_vdata,
  input wire in_blank,
  output reg out_hsync,
  output reg out_vsync,
  output reg [WIDTH-1:0] out_hdata,
  output reg [WIDTH-1:0] out_vdata,
  output reg out_blank
);

always @ (posedge clk)
begin
  out_hsync <= in_hsync;
  out_vsync <= in_vsync;
  out_hdata <= in_hdata;
  out_vdata <= in_vdata;
  out_blank <= in_blank;
end

endmodule
