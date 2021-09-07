module pipeline_reg1(
    input clk_i,
    input rst_n,
    input bjump_i,
    input lw_stall_i,
    
    input [4:0] rs1_from_IF_ID_i,
    input [4:0] rs2_from_IF_ID_i,
    input [4:0] rd_from_IF_ID_i,
    
    input [31:0] pc_from_preg0_i,
    input [31:0] read_data1_from_rf_i,
    input [31:0] read_data2_from_rf_i,
    input [31:0] instruction_from_preg0_i,
    input [31:0] ext_from_sext_i,
    output [31:0] pc_from_preg1_o,
    output [31:0] read_data1_from_preg1_o,
    output [31:0] read_data2_from_preg1_o,
    output [31:0] ext_from_preg1_o,
    output [31:0] instruction_from_preg1_o,
    
    output [4:0] rs1_from_ID_EX_o,
    output [4:0] rs2_from_ID_EX_o,
    output [4:0] rd_from_ID_EX_o
    );

reg [31:0] pc_from_preg1;
reg [31:0] read_data1_from_preg1;
reg [31:0] read_data2_from_preg1;
reg [31:0] instruction_from_preg1;
reg [31:0] ext_from_preg1;
assign pc_from_preg1_o = pc_from_preg1;
assign read_data1_from_preg1_o = read_data1_from_preg1;
assign read_data2_from_preg1_o = read_data2_from_preg1;
assign instruction_from_preg1_o = instruction_from_preg1;
assign ext_from_preg1_o = ext_from_preg1;

always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        pc_from_preg1 <= 32'hffff_fffc;
        read_data1_from_preg1 <= 0;
        read_data2_from_preg1 <= 0;
        instruction_from_preg1 <= 32'h0;
        ext_from_preg1 <= 0;
    end
    else if (lw_stall_i)
    begin
        pc_from_preg1 <= 32'hffff_fffc;
        read_data1_from_preg1 <= 0;
        read_data2_from_preg1 <= 0;
        instruction_from_preg1 <= 0;
        ext_from_preg1 <= ext_from_preg1;
    end
    else if (bjump_i)
    begin
        pc_from_preg1 <= 32'hffff_fffc;
        read_data1_from_preg1 <= 0;
        read_data2_from_preg1 <= 0;
        instruction_from_preg1 <= 32'h0;
        ext_from_preg1 <= 0;
    end
    else
    begin
        pc_from_preg1 <= pc_from_preg0_i;
        read_data1_from_preg1 <= read_data1_from_rf_i;
        read_data2_from_preg1 <= read_data2_from_rf_i;
        instruction_from_preg1 <= instruction_from_preg0_i;
        ext_from_preg1 <= ext_from_sext_i;
    end
end


reg [4:0] rs1_from_ID_EX;
reg [4:0] rs2_from_ID_EX;
reg [4:0] rd_from_ID_EX;
assign rs1_from_ID_EX_o = rs1_from_ID_EX;
assign rs2_from_ID_EX_o = rs2_from_ID_EX;
assign rd_from_ID_EX_o  = rd_from_ID_EX;

always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        rs1_from_ID_EX <= 0;
        rs2_from_ID_EX <= 0;
        rd_from_ID_EX  <= 0;
    end
    else if (lw_stall_i)
    begin
        rs1_from_ID_EX <= 0;
        rs2_from_ID_EX <= 0;
        rd_from_ID_EX  <= 0;
    end
    else if (bjump_i)
    begin
        rs1_from_ID_EX <= 0;
        rs2_from_ID_EX <= 0;
        rd_from_ID_EX  <= 0;
    end
    else
    begin
        rs1_from_ID_EX <= rs1_from_IF_ID_i;
        rs2_from_ID_EX <= rs2_from_IF_ID_i;
        rd_from_ID_EX  <= rd_from_IF_ID_i;
    end
end

endmodule

