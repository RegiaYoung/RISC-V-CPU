module pipeline_reg3(
    input clk_i,
    input rst_n,
    input lw_stall_i,
    input [31:0] read_data_from_dram_i,
    input [31:0] alu_result_from_preg2_i,
    input [31:0] instruction_from_preg2_i,
    input [31:0] ext_from_preg2_i,
    
    input [31:0] pc_from_preg2_i,
    
    output [31:0] read_data_from_preg3_o,
    output [31:0] alu_result_from_preg3_o,
    output [31:0] instruction_from_preg3_o,
    
    input [4:0] rs1_from_EX_MEM_i,
    input [4:0] rs2_from_EX_MEM_i,
    input [4:0] rd_from_EX_MEM_i,
    output [4:0] rs1_from_MEM_WB_o,
    output [4:0] rs2_from_MEM_WB_o,
    output [4:0] rd_from_MEM_WB_o,
    
    output [31:0] pc_from_preg3_o,
    output [31:0] ext_from_preg3_o
    );

reg [31:0] read_data_from_preg3;
reg [31:0] alu_result_from_preg3;
reg [31:0] instruction_from_preg3;
assign read_data_from_preg3_o = read_data_from_preg3;
assign alu_result_from_preg3_o = alu_result_from_preg3;
assign instruction_from_preg3_o = instruction_from_preg3;
always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        read_data_from_preg3 <= 0;
        alu_result_from_preg3 <= 0;
        instruction_from_preg3 <= 0;
    end
//    else if (lw_stall_i)
//    begin
//        read_data_from_preg3 <= 0;
//        alu_result_from_preg3 <= 0;
//        instruction_from_preg3 <= 0;
//    end
    else
    begin
        read_data_from_preg3 <= read_data_from_dram_i;
        alu_result_from_preg3 <= alu_result_from_preg2_i;
        instruction_from_preg3 <= instruction_from_preg2_i;
    end
end

reg [4:0] rs1_from_MEM_WB;
reg [4:0] rs2_from_MEM_WB;
reg [4:0] rd_from_MEM_WB;
assign rs1_from_MEM_WB_o = rs1_from_MEM_WB;
assign rs2_from_MEM_WB_o = rs2_from_MEM_WB;
assign rd_from_MEM_WB_o  = rd_from_MEM_WB;

always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        rs1_from_MEM_WB <= 0;
        rs2_from_MEM_WB <= 0;
        rd_from_MEM_WB  <= 0;
    end
    else if (lw_stall_i)
    begin
        rs1_from_MEM_WB <= 0;
        rs2_from_MEM_WB <= 0;
        rd_from_MEM_WB  <= 0;
    end
    else
    begin
        rs1_from_MEM_WB <= rs1_from_EX_MEM_i;
        rs2_from_MEM_WB <= rs2_from_EX_MEM_i;
        rd_from_MEM_WB  <= rd_from_EX_MEM_i;
    end
end

reg [31:0] pc_from_preg3;
reg [31:0] ext_from_preg3;
assign pc_from_preg3_o = pc_from_preg3;
assign ext_from_preg3_o = ext_from_preg3;
always @ (posedge clk_i)
begin
     if (~rst_n)
     begin
        pc_from_preg3 <= 32'hffff_fffc;
        ext_from_preg3 <= 0;
     end
//     else if (lw_stall_i)
//     begin
//        pc_from_preg3 <= 32'hffff_fffc;
//        ext_from_preg3 <= 0;
//     end
     else
     begin
        pc_from_preg3 <= pc_from_preg2_i;
        ext_from_preg3 <= ext_from_preg2_i;
     end
end

endmodule

