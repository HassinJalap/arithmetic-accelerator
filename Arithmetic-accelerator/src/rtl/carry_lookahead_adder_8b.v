`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 06:03:31 PM
// Design Name: 
// Module Name: carry_lookahead_adder_8b
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


module carry_lookahead_adder_8b (
    input   wire [7:0] iA, iB,
    input   wire                   iCarryIn,
    output  wire [7:0] oSum,
    output  wire                   oCarry
);
    wire w_oCarry;
    
    carry_lookahead_adder_4b CLA1(.iA(iA[3:0]), .iB(iB[3:0]), .iCarryIn(iCarryIn), .oSum(oSum[3:0]), .oCarry(w_oCarry));
    carry_lookahead_adder_4b CLA2(.iA(iA[7:4]), .iB(iB[7:4]), .iCarryIn(w_oCarry), .oSum(oSum[7:4]), .oCarry(oCarry));
    
endmodule
