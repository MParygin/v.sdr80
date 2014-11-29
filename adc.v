`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// 
// Create Date:    15:47:32 02/17/2012 
// Design Name: 
// Module Name:    adc 
// Project Name: 
// Description: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module adc(
   // ADC 80
	input wire clkA,
	input wire clkB,

	input wire L0_1_P,
	input wire L0_1_N,
	input wire L2_3_P,
	input wire L2_3_N,
	input wire L4_5_P,
	input wire L4_5_N,
	input wire L6_7_P,
	input wire L6_7_N,
	input wire L8_9_P,
	input wire L8_9_N,
	input wire L10_11_P,
	input wire L10_11_N,
	input wire L12_13_P,
	input wire L12_13_N,
	input wire L14_15_P,
	input wire L14_15_N,
	
	output wire dry,
	output reg [15:0] out,
	output wire locked,
	output wire toggled
);

wire clkin = clkA;
wire notclk = clkB; 

// Lines
wire L0_1;
wire L0;
wire L1;
IBUFDS #(.IOSTANDARD("LVDS_25"), .IBUF_DELAY_VALUE("0"), .DIFF_TERM("TRUE")) ibuf_0 (.I(L0_1_P), .IB(L0_1_N), .O(L0_1));
IDDR2 #(.DDR_ALIGNMENT("C0")) fd_0 (.C0(clkin), .C1(notclk), .D(L0_1), .CE(1'b1), .R(1'b0), .S(1'b0), .Q0(L0), .Q1(L1));

wire L2_3;
wire L2;
wire L3;
IBUFDS #(.IOSTANDARD("LVDS_25"), .IBUF_DELAY_VALUE("0"), .DIFF_TERM("TRUE")) ibuf_2 (.I(L2_3_P), .IB(L2_3_N), .O(L2_3));
IDDR2 #(.DDR_ALIGNMENT("C0")) fd_2 (.C0(clkin), .C1(notclk), .D(L2_3), .CE(1'b1), .R(1'b0), .S(1'b0), .Q0(L2), .Q1(L3));

wire L4_5;
wire L4;
wire L5;
IBUFDS #(.IOSTANDARD("LVDS_25"), .IBUF_DELAY_VALUE("0"), .DIFF_TERM("TRUE")) ibuf_4 (.I(L4_5_P), .IB(L4_5_N), .O(L4_5));
IDDR2 #(.DDR_ALIGNMENT("C0")) fd_4 (.C0(clkin), .C1(notclk), .D(L4_5), .CE(1'b1), .R(1'b0), .S(1'b0), .Q0(L4), .Q1(L5));

wire L6_7;
wire L6;
wire L7;
IBUFDS #(.IOSTANDARD("LVDS_25"), .IBUF_DELAY_VALUE("0"), .DIFF_TERM("TRUE")) ibuf_6 (.I(L6_7_P), .IB(L6_7_N), .O(L6_7));
IDDR2 #(.DDR_ALIGNMENT("C0")) fd_6 (.C0(clkin), .C1(notclk), .D(L6_7), .CE(1'b1), .R(1'b0), .S(1'b0), .Q0(L6), .Q1(L7));

wire L8_9;
wire L8;
wire L9;
IBUFDS #(.IOSTANDARD("LVDS_25"), .IBUF_DELAY_VALUE("0"), .DIFF_TERM("TRUE")) ibuf_8 (.I(L8_9_P), .IB(L8_9_N), .O(L8_9));
IDDR2 #(.DDR_ALIGNMENT("C0")) fd_8 (.C0(clkin), .C1(notclk), .D(L8_9), .CE(1'b1), .R(1'b0), .S(1'b0), .Q0(L8), .Q1(L9));

wire L10_11;
wire L10;
wire L11;
IBUFDS #(.IOSTANDARD("LVDS_25"), .IBUF_DELAY_VALUE("0"), .DIFF_TERM("TRUE")) ibuf_10 (.I(L10_11_P), .IB(L10_11_N), .O(L10_11));
IDDR2 #(.DDR_ALIGNMENT("C0")) fd_10 (.C0(clkin), .C1(notclk), .D(L10_11), .CE(1'b1), .R(1'b0), .S(1'b0), .Q0(L10), .Q1(L11));

wire L12_13;
wire L12;
wire L13;
IBUFDS #(.IOSTANDARD("LVDS_25"), .IBUF_DELAY_VALUE("0"), .DIFF_TERM("TRUE")) ibuf_12 (.I(L12_13_P), .IB(L12_13_N), .O(L12_13));
IDDR2 #(.DDR_ALIGNMENT("C0")) fd_12 (.C0(clkin), .C1(notclk), .D(L12_13), .CE(1'b1), .R(1'b0), .S(1'b0), .Q0(L12), .Q1(L13));

wire L14_15;
wire L14;
wire L15;
IBUFDS #(.IOSTANDARD("LVDS_25"), .IBUF_DELAY_VALUE("0"), .DIFF_TERM("TRUE")) ibuf_14 (.I(L14_15_P), .IB(L14_15_N), .O(L14_15));
IDDR2 #(.DDR_ALIGNMENT("C0")) fd_14 (.C0(clkin), .C1(notclk), .D(L14_15), .CE(1'b1), .R(1'b0), .S(1'b0), .Q0(L14), .Q1(L15));

assign dry = clkin;

reg [7:0] tmpbuf;

always @ (posedge clkin)
begin
  tmpbuf <= {L14, L12, L10, L8, L6, L4, L2, L0};
end

always @ (posedge notclk)
begin
  out[15] <= L15;
  out[14] <= tmpbuf[7];
  out[13] <= L13;
  out[12] <= tmpbuf[6];
  out[11] <= L11;
  out[10] <= tmpbuf[5];
  out[9] <= L9;
  out[8] <= tmpbuf[4];
  out[7] <= L7;
  out[6] <= tmpbuf[3];
  out[5] <= L5;
  out[4] <= tmpbuf[2];
  out[3] <= L3;
  out[2] <= tmpbuf[1];
  out[1] <= L1;
  out[0] <= tmpbuf[0];
end

endmodule
