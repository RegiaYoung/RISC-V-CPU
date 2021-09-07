module j_format_stall(
    input rst_n,
    input bstall_i,
    input clk_i,
    input [31:0] instruction_from_preg1_i,
    input [31:0] instruction_from_preg0_i,
    output jstall_o
    );
reg stall;
assign jstall_o = stall;
reg [2:0] counter = 0;
// stop for 3 cycles
always @ (posedge clk_i)
begin
    if (~rst_n)
        counter <= 0;
    else if (counter == 1)
        counter <= 0;
    else if (stall)
        counter <= counter + 1;
    else
        counter <= 0;
end
// stop for 3 cycles
always @ (*)
begin
    if (~rst_n)
        stall = 0;
    else if (bstall_i)
        stall = 0;
    else if (instruction_from_preg1_i[6:2] == 5'b11000)
        stall = 0;
    else if (instruction_from_preg0_i[6:2] == 5'b11011 || instruction_from_preg0_i[6:2] == 5'b11001)
        stall = 1;
    else if (counter != 0)
        stall = 1;
    else
        stall = 0;
end
endmodule
