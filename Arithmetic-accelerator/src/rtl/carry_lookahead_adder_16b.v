`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 05:41:42 PM
// Design Name: 
// Module Name: carry_lookahead_adder_16b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module carry_lookahead_adder_16b (
    input   wire [15:0] iA, iB,
    input   wire                   iCarryIn,
    output  wire [15:0] oSum,
    output  wire                   oCarry
);
    wire [2:0] w_oCarry;
    
    carry_lookahead_adder_4b CLA1(.iA(iA[3:0]), .iB(iB[3:0]), .iCarryIn(iCarryIn), .oSum(oSum[3:0]), .oCarry(w_oCarry[0]));
    carry_lookahead_adder_4b CLA2(.iA(iA[7:4]), .iB(iB[7:4]), .iCarryIn(w_oCarry[0]), .oSum(oSum[7:4]), .oCarry(w_oCarry[1]));
    carry_lookahead_adder_4b CLA3(.iA(iA[11:8]), .iB(iB[11:8]), .iCarryIn(w_oCarry[1]), .oSum(oSum[11:8]), .oCarry(w_oCarry[2]));
    carry_lookahead_adder_4b CLA4(.iA(iA[15:12]), .iB(iB[15:12]), .iCarryIn(w_oCarry[2]), .oSum(oSum[15:12]), .oCarry(oCarry));
endmodule
