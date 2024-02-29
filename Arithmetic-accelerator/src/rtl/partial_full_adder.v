`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 02:24:33 AM
// Design Name: 
// Module Name: partial_full_adder
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


module partial_full_adder(
    input   wire iA, iB,
    input   wire iCarryIn,
    output  wire oSum, oGen, oPropagate
    );
 
assign oSum = iA ^ iB ^ iCarryIn;
assign oGen = iA & iB;
assign oPropagate = iA | iB;

endmodule
