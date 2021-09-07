

module adder_for_plus_4(
    input [31:0] pc_from_pc_i,
    output [31:0] pc_plus_4_o
    );

reg [31:0] pc_plus_4;
assign pc_plus_4_o = pc_plus_4;
always @ (*)
begin
    pc_plus_4 = pc_from_pc_i + 4;
end
endmodule
