`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2023 12:25:50 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input   wire    iA, iB, iCarry,
    output  wire    oSum, oCarry
    );
    
    assign oCarry = (iA & iB) | (iCarry & (iA ^ iB) );
    assign oSum = (iA ^ iB) ^ iCarry;
    
    
endmodule
