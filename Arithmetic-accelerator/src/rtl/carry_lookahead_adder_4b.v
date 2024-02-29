`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module carry_lookahead_adder_4b #(
    parameter ADDER_WIDTH = 4
) (
    input   wire [ADDER_WIDTH-1:0] iA, iB,
    input   wire                   iCarryIn,
    output  wire [ADDER_WIDTH-1:0] oSum,
    output  wire                   oCarry
);
    
    wire [ADDER_WIDTH-1:0] wGen, wPropagate;
    
    partial_full_adder PFA1(
        .iA(iA[0]),
        .iB(iB[0]),
        .iCarryIn(iCarryIn),
        .oSum(oSum[0]),
        .oGen(wGen[0]),
        .oPropagate(wPropagate[0])
    );
    
    partial_full_adder PFA2(
        .iA(iA[1]),
        .iB(iB[1]),
        .iCarryIn(wCarry[0]), //Add carry input logic
        .oSum(oSum[1]),
        .oGen(wGen[1]),
        .oPropagate(wPropagate[1])
    );
    
    partial_full_adder PFA3(
        .iA(iA[2]),
        .iB(iB[2]),
        .iCarryIn(wCarry[1]), //Add carry input logic
        .oSum(oSum[2]),
        .oGen(wGen[2]),
        .oPropagate(wPropagate[2])
    );
    
    partial_full_adder PFA4(
        .iA(iA[3]),
        .iB(iB[3]),
        .iCarryIn(wCarry[2]), //Add carry input logic
        .oSum(oSum[3]),
        .oGen(wGen[3]),
        .oPropagate(wPropagate[3])
    );
    
    wire [ADDER_WIDTH-2:0] wCarry;
    
    assign wCarry[0] = wGen[0] | (wPropagate[0] & iCarryIn);
    assign wCarry[1] = wGen[1] | (wPropagate[1] & wGen[0]) | (wPropagate[1] & wPropagate[0] & iCarryIn);
    assign wCarry[2] = wGen[2] | (wPropagate[2] & wGen[1]) | (wPropagate[2] & wPropagate[1] & wGen[0]) | (wPropagate[2] & wPropagate[1] & wPropagate[0] & iCarryIn);
    assign oCarry    = wGen[3] | (wPropagate[3] & wGen[2]) | (wPropagate[3] & wPropagate[2] & wGen[1]) | (wPropagate[3] & wPropagate[2] & wPropagate[1] & wGen[0]) | (wPropagate[3] & wPropagate[2] & wPropagate[1] & wPropagate[0] & iCarryIn); 

endmodule
