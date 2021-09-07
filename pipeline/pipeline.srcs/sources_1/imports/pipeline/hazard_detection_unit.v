module hazard_detection_unit(
    input rst_n,
    input clk_i,
    input [31:0] instruction_from_preg1_i,
    input [4:0] rd_from_ID_EX_i,
    input [4:0] rs1_from_IF_ID_i,
    input [4:0] rs2_from_IF_ID_i,
    output lw_stall_o
    );
reg lw_stall;
// stop for 2 cycles
reg counter = 0;
always @ (posedge clk_i)
begin
    if (~rst_n)
        counter <= 0;
    else if (lw_stall)
        counter <= counter + 1;
    else
        counter <= 0;
end

reg [1:0] stop_for_2_cycles = 0;
always @ (posedge clk_i)
begin
    if (~rst_n)
        stop_for_2_cycles <= 0;
    else if (instruction_from_preg1_i[6:0] == 7'b0000011 && instruction_from_preg1_i[14:12] != 3'b010)
        stop_for_2_cycles <= stop_for_2_cycles + 1;
    else if (stop_for_2_cycles == 1)
        stop_for_2_cycles <= stop_for_2_cycles + 1;
    else
        stop_for_2_cycles <= 0;
end
always @ (posedge clk_i)
begin
    
end
assign lw_stall_o = lw_stall;
always @ (*)
begin
    if (~rst_n)
        lw_stall = 0;
    else if (stop_for_2_cycles)
        lw_stall = 1;
    else if (counter)
        lw_stall = 0;
    else if (instruction_from_preg1_i[6:2] != 5'b00000)
        lw_stall = 0;
    else if (rd_from_ID_EX_i == 0)
        lw_stall = 0;
    else if (rd_from_ID_EX_i == rs1_from_IF_ID_i || rd_from_ID_EX_i == rs2_from_IF_ID_i)
        lw_stall = 1;
    else
        lw_stall = 0;
end

endmodule

