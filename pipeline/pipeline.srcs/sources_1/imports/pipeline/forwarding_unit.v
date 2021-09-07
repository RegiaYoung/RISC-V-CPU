module forwarding_unit(
    input rst_n,
    input clk_i,
    input [31:0] instruction_from_preg3_i,
    input [31:0] instruction_from_preg2_i,
    input [31:0] instruction_from_preg1_i,
    input [31:0] instruction_before_i,
    input [4:0] rd_before_i,
    input reg_wen_before_i,
    input A_sel_i,
    input B_sel_i,
    input [4:0] rs1_from_ID_EX_i,
    input [4:0] rs2_from_ID_EX_i,
    input [4:0] rd_from_EX_MEM_i,
    input [4:0] rd_from_MEM_WB_i,
    output [2:0] forwarding_A_o,
    output [2:0] forwarding_B_o ,
    output [2:0] sw_forwarding_B_o
    );

// EX harzard
reg [2:0] forwarding_A;
reg [2:0] forwarding_B;
assign forwarding_A_o = forwarding_A;

reg EX_forwarding_A;
reg EX_forwarding_B;
always @ (*)
begin
    if (~rst_n)
    begin
        EX_forwarding_A = 0;
        EX_forwarding_B = 0;
    end
    else if (instruction_from_preg2_i[6:0] == 5'b01000 || instruction_from_preg2_i[6:0] == 5'b11000)
    begin
        EX_forwarding_A = 0;
        EX_forwarding_B = 0;
    end
    else if (rd_from_EX_MEM_i == 0)
    begin
        EX_forwarding_A = 0;
        EX_forwarding_B = 0;
    end
    else if (rd_from_EX_MEM_i == rs1_from_ID_EX_i && rd_from_EX_MEM_i == rs2_from_ID_EX_i)
    begin
        EX_forwarding_A = 1;
        EX_forwarding_B = 1;
    end
    else if (rd_from_EX_MEM_i == rs1_from_ID_EX_i)
    begin
        EX_forwarding_A = 1;
        EX_forwarding_B = 0;
    end
    else if (rd_from_EX_MEM_i == rs2_from_ID_EX_i)
    begin
        EX_forwarding_A = 0;
        EX_forwarding_B = 1;
    end
    else
    begin
        EX_forwarding_A = 0;
        EX_forwarding_B = 0;
    end
end

reg MEM_forwarding_A;
reg MEM_forwarding_B;
always @ (*)
begin
    if (~rst_n)
    begin
        MEM_forwarding_A = 0;
        MEM_forwarding_B = 0;
    end
    else if (rd_from_MEM_WB_i == 0)
    begin
        MEM_forwarding_A = 0;
        MEM_forwarding_B = 0;
    end
    else if (rd_from_MEM_WB_i == rs1_from_ID_EX_i && rd_from_MEM_WB_i == rs2_from_ID_EX_i)
    begin
        MEM_forwarding_A = 1;
        MEM_forwarding_B = 1;
    end
    else if (rd_from_MEM_WB_i == rs1_from_ID_EX_i)
    begin
        MEM_forwarding_A = 1;
        MEM_forwarding_B = 0;
    end
    else if (rd_from_MEM_WB_i == rs2_from_ID_EX_i)
    begin
        MEM_forwarding_A = 0;
        MEM_forwarding_B = 1;
    end
    else
    begin
        MEM_forwarding_A = 0;
        MEM_forwarding_B = 0;
    end
end

reg LW_forwarding_A;
reg LW_forwarding_B;
always @ (*)
begin
    if (~rst_n)
    begin
        LW_forwarding_A = 0;
        LW_forwarding_B = 0;
    end
    else if (instruction_from_preg3_i[6:0] != 7'b0000011)
    begin
        LW_forwarding_A = 0;
        LW_forwarding_B = 0;
    end
    else if (rd_from_MEM_WB_i == rs1_from_ID_EX_i && rd_from_MEM_WB_i == rs2_from_ID_EX_i)
    begin
        LW_forwarding_A = 1;
        LW_forwarding_B = 1;
    end
    else if (rd_from_MEM_WB_i == rs1_from_ID_EX_i)
    begin
        LW_forwarding_A = 1;
        LW_forwarding_B = 0;
    end
    else if (rd_from_MEM_WB_i == rs2_from_ID_EX_i)
    begin
        LW_forwarding_A = 0;
        LW_forwarding_B = 1;
    end
    else
    begin
        LW_forwarding_A = 0;
        LW_forwarding_B = 0;
    end
end

reg forwarding_A_before_LW;
reg forwarding_B_before_LW;
always @ (*)
begin
    if (~rst_n)
    begin
        forwarding_A_before_LW = 0;
        forwarding_B_before_LW = 0;
    end
    else if (instruction_before_i[11:7] == 0)
    begin
        forwarding_A_before_LW = 0;
        forwarding_B_before_LW = 0;
    end
    else if (instruction_from_preg3_i[6:0] != 7'b0000011 && instruction_from_preg3_i[6:0] != 7'b0110111)
    begin
        forwarding_A_before_LW = 0;
        forwarding_B_before_LW = 0;
    end
    else if (instruction_before_i[6:2] == 5'b01000 || instruction_before_i[6:2] == 5'b11000)
    begin
        forwarding_A_before_LW = 0;
        forwarding_B_before_LW = 0;
    end
    else if (instruction_before_i[11:7] == rs1_from_ID_EX_i && instruction_before_i[11:7] == rs2_from_ID_EX_i)
    begin
        forwarding_A_before_LW = 1;
        forwarding_B_before_LW = 1;
    end
    else if (instruction_before_i[11:7] == rs1_from_ID_EX_i)
    begin
        forwarding_A_before_LW = 1;
        forwarding_B_before_LW = 0;
    end
    else if (instruction_before_i[11:7] == rs2_from_ID_EX_i)
    begin
        forwarding_A_before_LW = 0;
        forwarding_B_before_LW = 1;
    end
    else
    begin
        forwarding_A_before_LW = 0;
        forwarding_B_before_LW = 0;
    end
end

reg [4:0] rd_before;
always @ (posedge clk_i)
begin
    if (~rst_n)
        rd_before <= 0;
    else
        rd_before <= rd_before_i;
end
always @ (*)
begin
    if (~rst_n)
        forwarding_A = 0;
    else if (instruction_from_preg1_i[6:2] == 5'b11000)
    begin
        forwarding_A[2:1] = 2'b00;
        forwarding_A[0] = A_sel_i;
    end
    else if (instruction_from_preg1_i[6:2] == 5'b01101)
        forwarding_A = 3'b110;
    else if (LW_forwarding_A == 1)
        forwarding_A = 3'b100;
    else if (forwarding_A_before_LW == 1)
        forwarding_A = 3'b101;
    else if (EX_forwarding_A == 1)
        forwarding_A = 3'b010;
    else if (MEM_forwarding_A == 1)
        forwarding_A = 3'b011;
    else if (rd_before != 0 && reg_wen_before_i == 1 && rd_before == rs1_from_ID_EX_i)
    begin
        forwarding_A = 3'b101;
    end
    else
    begin
        forwarding_A[2:1] = 2'b00;
        forwarding_A[0] = A_sel_i;
    end
end

reg [2:0] alu_forwarding_B;
reg [2:0] sw_forwarding_B;
assign forwarding_B_o = alu_forwarding_B;
assign sw_forwarding_B_o = sw_forwarding_B;
always @ (*)
begin
    if (~rst_n)
        forwarding_B = 0;
    else if (instruction_from_preg1_i[6:2] == 5'b11000)
    begin
        forwarding_B[2:1] = 2'b00;
        forwarding_B[0] = B_sel_i;
    end
    else if (instruction_from_preg1_i[6:2] != 5'b01100 && instruction_from_preg1_i[6:2] != 5'b01000 && instruction_from_preg1_i[6:2] != 5'b11000)
    begin
        forwarding_B[2:1] = 2'b00;
        forwarding_B[0] = B_sel_i;
    end
    else if (LW_forwarding_B == 1)
        forwarding_B = 3'b100;
    else if (forwarding_B_before_LW == 1)
        forwarding_B = 3'b101;
    else if (EX_forwarding_B == 1)
        forwarding_B = 3'b010;
    else if (MEM_forwarding_B == 1)
        forwarding_B = 3'b011;
    else if (rd_before != 0 && reg_wen_before_i == 1 && rd_before == rs2_from_ID_EX_i)
    begin
        forwarding_B = 3'b101;
    end
    else
    begin
        forwarding_B[2:1] = 2'b00;
        forwarding_B[0] = B_sel_i;
    end
end
always @ (*)
begin
    if (~rst_n)
        alu_forwarding_B = 0;
    else if (instruction_from_preg1_i[6:2] == 5'b01000)     // s format
    begin
        alu_forwarding_B[2:1] = 2'b00;
        alu_forwarding_B[0] = B_sel_i;
        sw_forwarding_B = forwarding_B;
    end
    else
        alu_forwarding_B = forwarding_B;
end
endmodule

