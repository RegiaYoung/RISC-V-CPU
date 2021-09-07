
module logic_calculation(
    input [3:0] logic_op_sel_i,
    input [31:0] operand_A_i,
    input [31:0] operand_B_i,
    output [31:0] result_from_logic_o
    );


reg [31:0] result;
assign result_from_logic_o = result;
always @ (*)
begin
    case(logic_op_sel_i)
        `AND:    result = operand_A_i & operand_B_i;
        `OR:     result = operand_A_i | operand_B_i;
        `XOR:    result = operand_A_i ^ operand_B_i;
        default:result = 0;
    endcase
end
endmodule
