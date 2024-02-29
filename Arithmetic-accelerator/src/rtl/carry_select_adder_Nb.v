`timescale 1ns / 1ps

module carry_select_adder_Nb #(
    parameter ADDER_WIDTH = 128,
    parameter SUB_WIDTH = 16
) (
    input   wire [ADDER_WIDTH-1:0] iA, iB,
    input   wire                   iCarryIn,
    output  wire [ADDER_WIDTH-1:0] oSum,
    output  wire                   oCarry
);
    wire oCarry1;
    wire [1:0] oCarryFA [0:ADDER_WIDTH/SUB_WIDTH-1];
    wire [SUB_WIDTH-1:0] oSumFA [0:ADDER_WIDTH/SUB_WIDTH-1][0:1];
    
    carry_lookahead_adder_16b CLA(.iA(iA[SUB_WIDTH-1:0]), .iB(iB[SUB_WIDTH-1:0]), .iCarryIn(iCarryIn), .oSum(oSum[SUB_WIDTH-1:0]), .oCarry(oCarry1));
    genvar i;
    generate
        for (i = SUB_WIDTH; i < ADDER_WIDTH; i = i + SUB_WIDTH)
        begin : adders
            carry_lookahead_adder_16b CLA_noCarry(.iA(iA[i+SUB_WIDTH-1:i]), .iB(iB[i+SUB_WIDTH-1:i]), .iCarryIn(1'b0), .oSum(oSumFA[i/SUB_WIDTH][0]), .oCarry(oCarryFA[i/SUB_WIDTH][0]));
            carry_lookahead_adder_16b CLA_carry(.iA(iA[i+SUB_WIDTH-1:i]), .iB(iB[i+SUB_WIDTH-1:i]), .iCarryIn(1'b1), .oSum(oSumFA[i/SUB_WIDTH][1]), .oCarry(oCarryFA[i/SUB_WIDTH][1]));
        end
    endgenerate

    wire [1:ADDER_WIDTH/SUB_WIDTH-1] mux_select;
    assign mux_select[1] = (oCarry1 == 0) ? oCarryFA[1][0] : oCarryFA[1][1];
    genvar j;
    generate
        for (j = 2; j < ADDER_WIDTH/SUB_WIDTH; j = j + 1)
        begin
            assign mux_select[j] = (mux_select[j-1] == 0) ? oCarryFA[j-1][0] : oCarryFA[j-1][1];
        end
    endgenerate


    generate
        genvar l;
        for (l = 0; l < SUB_WIDTH; l = l + 1)
        begin : assign_bit
            assign oSum[SUB_WIDTH + l] = (oCarry1 == 0) ? oSumFA[1][0][l] : oSumFA[1][1][l];
        end
    endgenerate
    
    genvar k;
    generate
        for (k = SUB_WIDTH*2; k < ADDER_WIDTH; k = k + SUB_WIDTH)
        begin : assign_sum
            genvar l;
            for (l = 0; l < SUB_WIDTH; l = l + 1)
            begin : assign_bit
                assign oSum[k+l] = (mux_select[k/SUB_WIDTH] == 0) ? oSumFA[k/SUB_WIDTH][0][l] : oSumFA[k/SUB_WIDTH][1][l];
            end
        end
    endgenerate


    assign oCarry = (mux_select[ADDER_WIDTH/SUB_WIDTH-1] == 0) ? oCarryFA[ADDER_WIDTH/SUB_WIDTH-1][0] : oCarryFA[ADDER_WIDTH/SUB_WIDTH-1][1];

endmodule