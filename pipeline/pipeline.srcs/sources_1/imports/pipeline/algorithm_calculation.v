
module algorithm_calculation(
    input [3:0] algorithm_op_sel_i,
    input [31:0] operand_A_i,
    input [31:0] operand_B_i,
    output [31:0] result_from_algorithm_o
    );



reg [31:0] result;
assign result_from_algorithm_o = result;
always @ (*)
begin
    case(algorithm_op_sel_i)
        `ADD:    result = operand_A_i + operand_B_i;
        `SUB:    result = operand_A_i + (operand_B_i ^ 32'b1111_1111_1111_1111_1111_1111_1111_1111) + 1'b1;
        default:result = 0;
    endcase
end
endmodule
