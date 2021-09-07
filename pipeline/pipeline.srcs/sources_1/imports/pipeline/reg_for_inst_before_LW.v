module reg_for_inst_before_LW(
    input rst_n,
    input clk_i,
    input [31:0] instruction_from_preg3_i,
    output [31:0] instruction_before_o
    );
reg [31:0] instruction_before;
assign instruction_before_o = instruction_before;
always @ (posedge clk_i)
begin
    if (~rst_n)
        instruction_before <= 0;
    else
        instruction_before <= instruction_from_preg3_i;
end

endmodule
