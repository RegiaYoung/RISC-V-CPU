module pipeline_reg0(
    input clk_i,
    input rst_n,
    input bjump_i,
    input lw_stall_i,
    input jstall_i,
    
    input [31:0] pc_from_pc_i,
    input [31:0] instruction_from_irom_i,
    output [31:0] pc_from_preg0_o,
    output [31:0] instruction_from_preg0_o,
    
    output [4:0] rs1_from_IF_ID_o,
    output [4:0] rs2_from_IF_ID_o,
    output [4:0] rd_from_IF_ID_o
    );

reg [31:0] pc_from_preg0;
reg [31:0] instruction_from_preg0;
assign pc_from_preg0_o = pc_from_preg0;
assign instruction_from_preg0_o = instruction_from_preg0;
always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        pc_from_preg0 <= 32'hffff_fffc;
        instruction_from_preg0 <= 32'h0;
    end
    else if (bjump_i)       // clear
    begin
        pc_from_preg0 <= 32'hffff_fffc;
        instruction_from_preg0 <= 32'h0;
    end
    else if (jstall_i)
    begin
        pc_from_preg0 <= 32'hffff_fffc;
        instruction_from_preg0 <= 32'h0;
    end
    else if (lw_stall_i)
    begin
        pc_from_preg0 <= pc_from_preg0;
        instruction_from_preg0 <= instruction_from_preg0;
    end
    else
    begin
        pc_from_preg0 <= pc_from_pc_i;
        instruction_from_preg0 <= instruction_from_irom_i;
    end
end

reg [4:0] rs1_from_IF_ID;
reg [4:0] rs2_from_IF_ID;
reg [4:0] rd_from_IF_ID;
assign rs1_from_IF_ID_o = rs1_from_IF_ID;
assign rs2_from_IF_ID_o = rs2_from_IF_ID;
assign rd_from_IF_ID_o = rd_from_IF_ID;
always @ (posedge clk_i)
begin
     if (~rst_n)
        rs1_from_IF_ID <= 0;
     else if (bjump_i)
        rs1_from_IF_ID <= 0;
     else if (jstall_i)
        rs1_from_IF_ID <= 0;
     else if (lw_stall_i)
        rs1_from_IF_ID <= rs1_from_IF_ID;
     else if (instruction_from_irom_i[6:2] == 5'b01101)
        rs1_from_IF_ID <= 0;
     else if (instruction_from_irom_i[6:2] == 5'b00101)
        rs1_from_IF_ID <= 0;
     else if (instruction_from_irom_i[6:2] == 5'b11011)
        rs1_from_IF_ID <= 0;
     else
        rs1_from_IF_ID <= instruction_from_irom_i[19:15];
end
always @ (posedge clk_i)
begin
    if (~rst_n)
        rs2_from_IF_ID <= 0;
    else if (bjump_i)
        rs2_from_IF_ID <= 0;
    else if (jstall_i)
        rs2_from_IF_ID <= 0;
    else if (lw_stall_i)
        rs2_from_IF_ID <= rs2_from_IF_ID;
    else if (instruction_from_irom_i[6:2] == 5'b01100)
        rs2_from_IF_ID <= instruction_from_irom_i[24:20];
    else if (instruction_from_irom_i[6:2] == 5'b01000)
        rs2_from_IF_ID <= instruction_from_irom_i[24:20];
    else if (instruction_from_irom_i[6:2] == 5'b11000)
        rs2_from_IF_ID <= instruction_from_irom_i[24:20];
    else
        rs2_from_IF_ID <= 0;
end
always @ (posedge clk_i)
begin
    if (~rst_n)
        rd_from_IF_ID <= 0;
    else if (bjump_i)
        rd_from_IF_ID <= 0;
    else if (jstall_i)
        rd_from_IF_ID <= 0;
    else if (lw_stall_i)
        rd_from_IF_ID <= rd_from_IF_ID;
    else if (instruction_from_irom_i[6:2] == 5'b01000)
        rd_from_IF_ID <= 0;
    else if (instruction_from_irom_i[6:2] == 5'b11000)
        rd_from_IF_ID <= 0;
    else
        rd_from_IF_ID <= instruction_from_irom_i[11:7];
end
endmodule
