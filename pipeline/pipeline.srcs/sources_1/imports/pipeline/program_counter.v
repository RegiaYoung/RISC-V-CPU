module program_counter(
    input clk_i,
    input reset_i,
    input stall_i,
    input [31:0] next_pc_i,
    output [31:0] pc_o
    );
reg [31:0] pc;
assign pc_o = pc;

always @ (posedge clk_i or posedge reset_i)
begin
    if (reset_i)    pc <= 'hffff_fffc;
    else if (stall_i) pc <= pc;
    else            pc <= next_pc_i;
end


endmodule
