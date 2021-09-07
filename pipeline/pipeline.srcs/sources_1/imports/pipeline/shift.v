`include "param.v"

module shift(
    input [3:0] shift_op_sel_i,
    input [31:0] operand_A_i,
    input [31:0] operand_B_i,
    output [31:0] result_from_shift_o
    );

reg [31:0] result;
assign result_from_shift_o = result;


reg [31:0] sll_result;
always @ (*)
begin
    case (operand_B_i)
        0:  sll_result = operand_A_i;
        1:  sll_result = (operand_A_i << 1);
        2:  sll_result = (operand_A_i << 2);
        3:  sll_result = (operand_A_i << 3);
        4:  sll_result = (operand_A_i << 4);
        5:  sll_result = (operand_A_i << 5);
        6:  sll_result = (operand_A_i << 6);
        7:  sll_result = (operand_A_i << 7);
        8:  sll_result = (operand_A_i << 8);
        9:  sll_result = (operand_A_i << 9);
        10: sll_result = (operand_A_i << 10);
        11: sll_result = (operand_A_i << 11);
        12: sll_result = (operand_A_i << 12);
        13: sll_result = (operand_A_i << 13);
        14: sll_result = (operand_A_i << 14);
        15: sll_result = (operand_A_i << 15);
        16: sll_result = (operand_A_i << 16);
        17: sll_result = (operand_A_i << 17);
        18: sll_result = (operand_A_i << 18);
        19: sll_result = (operand_A_i << 19);
        20: sll_result = (operand_A_i << 20);
        21: sll_result = (operand_A_i << 21);
        22: sll_result = (operand_A_i << 22);
        23: sll_result = (operand_A_i << 23);
        24: sll_result = (operand_A_i << 24);
        25: sll_result = (operand_A_i << 25);
        26: sll_result = (operand_A_i << 26);
        27: sll_result = (operand_A_i << 27);
        28: sll_result = (operand_A_i << 28);
        29: sll_result = (operand_A_i << 29);
        30: sll_result = (operand_A_i << 30);
        31: sll_result = (operand_A_i << 31);
        default: sll_result = operand_A_i;
    endcase
end

reg [31:0] srl_result;
always @ (*)
begin
    case (operand_B_i)
        0:  srl_result = operand_A_i;
        1:  srl_result = (operand_A_i >> 1);
        2:  srl_result = (operand_A_i >> 2);
        3:  srl_result = (operand_A_i >> 3);
        4:  srl_result = (operand_A_i >> 4);
        5:  srl_result = (operand_A_i >> 5);
        6:  srl_result = (operand_A_i >> 6);
        7:  srl_result = (operand_A_i >> 7);
        8:  srl_result = (operand_A_i >> 8);
        9:  srl_result = (operand_A_i >> 9);
        10: srl_result = (operand_A_i >> 10);
        11: srl_result = (operand_A_i >> 11);
        12: srl_result = (operand_A_i >> 12);
        13: srl_result = (operand_A_i >> 13);
        14: srl_result = (operand_A_i >> 14);
        15: srl_result = (operand_A_i >> 15);
        16: srl_result = (operand_A_i >> 16);
        17: srl_result = (operand_A_i >> 17);
        18: srl_result = (operand_A_i >> 18);
        19: srl_result = (operand_A_i >> 19);
        20: srl_result = (operand_A_i >> 20);
        21: srl_result = (operand_A_i >> 21);
        22: srl_result = (operand_A_i >> 22);
        23: srl_result = (operand_A_i >> 23);
        24: srl_result = (operand_A_i >> 24);
        25: srl_result = (operand_A_i >> 25);
        26: srl_result = (operand_A_i >> 26);
        27: srl_result = (operand_A_i >> 27);
        28: srl_result = (operand_A_i >> 28);
        29: srl_result = (operand_A_i >> 29);
        30: srl_result = (operand_A_i >> 30);
        31: srl_result = (operand_A_i >> 31);
        default: srl_result = operand_A_i;
    endcase
end

reg [31:0] sra_result;
always @ (*)
begin
    case (operand_B_i)
        0:  sra_result = operand_A_i;
        1:  sra_result = (($signed(operand_A_i)) >>> 1);
        2:  sra_result = (($signed(operand_A_i)) >>> 2);
        3:  sra_result = (($signed(operand_A_i)) >>> 3);
        4:  sra_result = (($signed(operand_A_i)) >>> 4);
        5:  sra_result = (($signed(operand_A_i)) >>> 5);
        6:  sra_result = (($signed(operand_A_i)) >>> 6);
        7:  sra_result = (($signed(operand_A_i)) >>> 7);
        8:  sra_result = (($signed(operand_A_i)) >>> 8);
        9:  sra_result = (($signed(operand_A_i)) >>> 9);
        10: sra_result = (($signed(operand_A_i)) >>> 10);
        11: sra_result = (($signed(operand_A_i)) >>> 11);
        12: sra_result = (($signed(operand_A_i)) >>> 12);
        13: sra_result = (($signed(operand_A_i)) >>> 13);
        14: sra_result = (($signed(operand_A_i)) >>> 14);
        15: sra_result = (($signed(operand_A_i)) >>> 15);
        16: sra_result = (($signed(operand_A_i)) >>> 16);
        17: sra_result = (($signed(operand_A_i)) >>> 17);
        18: sra_result = (($signed(operand_A_i)) >>> 18);
        19: sra_result = (($signed(operand_A_i)) >>> 19);
        20: sra_result = (($signed(operand_A_i)) >>> 20);
        21: sra_result = (($signed(operand_A_i)) >>> 21);
        22: sra_result = (($signed(operand_A_i)) >>> 22);
        23: sra_result = (($signed(operand_A_i)) >>> 23);
        24: sra_result = (($signed(operand_A_i)) >>> 24);
        25: sra_result = (($signed(operand_A_i)) >>> 25);
        26: sra_result = (($signed(operand_A_i)) >>> 26);
        27: sra_result = (($signed(operand_A_i)) >>> 27);
        28: sra_result = (($signed(operand_A_i)) >>> 28);
        29: sra_result = (($signed(operand_A_i)) >>> 29);
        30: sra_result = (($signed(operand_A_i)) >>> 30);
        31: sra_result = (($signed(operand_A_i)) >>> 31);
        default: sra_result = operand_A_i;
    endcase
end

always @ (*)
begin
    case(shift_op_sel_i)
        `SLL:    result = sll_result;
        `SRL:    result = srl_result;
        `SRA:    result = sra_result;
        default:result = 0;
    endcase
end

endmodule
