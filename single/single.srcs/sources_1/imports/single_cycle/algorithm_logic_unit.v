
module algorithm_logic_unit(
    input [31:0] operand_A_i,
    input [31:0] operand_B_i,
    input [3:0] op_sel_i,
    output [31:0] result_from_alu_o
    );


// algorithm_calculation unit
wire [31:0] result_from_algorithm;
algorithm_calculation U_algorithm_calculation(
    .algorithm_op_sel_i(op_sel_i),          // input wire [2:0] algorithm_op_sel
    .operand_A_i(operand_A_i),              // input wire [31:0] operand_A
    .operand_B_i(operand_B_i),              // input wire [31:0] operand_B
    .result_from_algorithm_o(result_from_algorithm)// output wire [31:0] result from algorithm calculatin unit
    );

// logic calculation unit
wire [31:0] result_from_logic;
logic_calculation U_logic_calculation(
    .operand_A_i(operand_A_i),          // input wire [31:0] operand_A
    .operand_B_i(operand_B_i),          // input wire [31:0] operand_B
    .logic_op_sel_i(op_sel_i),          // input wire [1:0] logic_op_sel
    .result_from_logic_o(result_from_logic)// output wire [31;0] result from logic calculation unit
    );

// shift unit
wire [31:0] result_from_shift;
wire [31:0] operand_B_for_shift;
assign operand_B_for_shift = operand_B_i%32;
shift U_shift(
    .shift_op_sel_i(op_sel_i),          // input wire [2:0] shift_op_sel
    .operand_A_i(operand_A_i),          // input wire [31:0] operand_A
    .operand_B_i(operand_B_for_shift),          // input wire [31:0] operand_B
    .result_from_shift_o(result_from_shift)// output wire [31:0] result from shift unit
    );

reg [31:0] result_from_alu;
assign result_from_alu_o = result_from_alu;
always @ (*)
begin
    if (op_sel_i < 2)           result_from_alu = result_from_algorithm;
    else if (op_sel_i < 5)      result_from_alu = result_from_logic;
    else if (op_sel_i < 8)      result_from_alu = result_from_shift;
    else
    begin
        if (op_sel_i == `SLT || op_sel_i == `SLTI)   result_from_alu = (($signed(operand_A_i) < $signed(operand_B_i)) ? 1 : 0);
        else                    result_from_alu = (operand_A_i < operand_B_i) ? 1 : 0;     // SLTU
    end
end
endmodule
