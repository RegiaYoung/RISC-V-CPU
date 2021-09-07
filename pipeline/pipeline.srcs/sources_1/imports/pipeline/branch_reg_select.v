module branch_reg_select(
    input rst_n,
    input clk_i,
    input [31:0] instruction_from_preg2_i,
    input [31:0] read_data1_from_preg2_i,
    input [31:0] read_data2_from_preg2_i,
    
    input reg_wen_before_i,
    input [31:0] wb_value_before_i,
    input [4:0]  rd_before_i,
    
    output [31:0] wb_value_before_o,
    output [31:0] cmp_value1_o,
    output [31:0] cmp_value2_o
    );

reg [31:0] wb_value_before_2;
reg [31:0] wb_value_before_1;
reg [4:0]  rd_before_2;
reg [4:0]  rd_before_1;
reg [4:0]  rd_before;
always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        wb_value_before_2 <= 0;
        rd_before_2 <= 0;
    end
    else
    begin
        wb_value_before_2 <= wb_value_before_1;
        rd_before_2 <= rd_before_1;
    end
end
always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        wb_value_before_1 <= 0;
        rd_before_1 <= 0;
    end
    else if (reg_wen_before_i)
    begin
        wb_value_before_1 <= wb_value_before_i;
        rd_before_1 <= rd_before_i;
    end
    else
    begin
        wb_value_before_1 <= 0;
        rd_before_1 <= 0;
    end
end

reg [4:0] rs1;
reg [4:0] rs2;
always @ (*)
begin
    if (~rst_n)
    begin
        rs2 = 0;
        rs1 = 0;
    end
    else
    begin
        rs2 = instruction_from_preg2_i[24:20];
        rs1 = instruction_from_preg2_i[19:15];
    end
end

reg [31:0] cmp_value_2;
reg [31:0] cmp_value_1;
assign cmp_value2_o = cmp_value_2;
assign cmp_value1_o = cmp_value_1;
always @ (*)
begin
    if (~rst_n)
        cmp_value_2 = 0;
    else if (rs2 == rd_before_i && rs2 != 0)
        cmp_value_2 = wb_value_before_i;
    else if (rs2 == rd_before_1 && rs2 != 0)
        cmp_value_2 = wb_value_before_1;
    else if (rs2 == rd_before_2 && rs2 != 0)
        cmp_value_2 = wb_value_before_2;
    else
        cmp_value_2 = read_data2_from_preg2_i;
end
always @ (*)
begin
    if (~rst_n)
        cmp_value_1 = 0;
    else if (rs1 == rd_before_i && rs1 != 0)
        cmp_value_1 = wb_value_before_i;
    else if (rs1 == rd_before_1 && rs1 != 0)
        cmp_value_1 = wb_value_before_1;
    else if (rs1 == rd_before_2 && rs1 != 0)
        cmp_value_1 = wb_value_before_2;
    else
        cmp_value_1 = read_data1_from_preg2_i;
end
assign wb_value_before_o = wb_value_before_1;

endmodule
