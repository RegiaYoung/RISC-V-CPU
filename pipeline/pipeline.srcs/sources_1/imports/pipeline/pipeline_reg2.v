module pipeline_reg2(
    input clk_i,
    input rst_n,
    input bjump_i,
    input lw_stall_i,
    input [31:0] result_from_alu_i,
    input [31:0] read_data1_from_preg1_i,
    input [31:0] read_data2_from_preg1_i,
    input [31:0] instruction_from_preg1_i,
    
    input [31:0] pc_from_preg1_i,
    input [31:0] ext_from_preg1_i,
    
    output [31:0] alu_result_from_preg2_o,
    output [31:0] read_data1_from_preg2_o,
    output [31:0] read_data2_from_preg2_o,
    output [31:0] instruction_from_preg2_o,
    
    input [4:0] rs1_from_ID_EX_i,
    input [4:0] rs2_from_ID_EX_i,
    input [4:0] rd_from_ID_EX_i,
    output [4:0] rs1_from_EX_MEM_o,
    output [4:0] rs2_from_EX_MEM_o,
    output [4:0] rd_from_EX_MEM_o,
    
    output [31:0] pc_from_preg2_o,
    output [31:0] ext_from_preg2_o
    );

reg [31:0] alu_result_from_preg2;
reg [31:0] read_data1_from_preg2;
reg [31:0] read_data2_from_preg2;
reg [31:0] instruction_from_preg2;
assign alu_result_from_preg2_o = alu_result_from_preg2;
assign read_data1_from_preg2_o = read_data1_from_preg2;
assign read_data2_from_preg2_o = read_data2_from_preg2;
assign instruction_from_preg2_o = instruction_from_preg2;
always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        alu_result_from_preg2 <= 0;
        read_data1_from_preg2 <= 0;
        read_data2_from_preg2 <= 0;
        instruction_from_preg2 <= 0;
    end
//    else if (lw_stall_i)
//    begin
//        alu_result_from_preg2 <= alu_result_from_preg2;
//        read_data1_from_preg2 <= read_data1_from_preg2;
//        read_data2_from_preg2 <= read_data2_from_preg2;
//        instruction_from_preg2 <= instruction_from_preg2;
//    end
    else if (bjump_i)
    begin
        alu_result_from_preg2 <= 0;
        read_data1_from_preg2 <= 0;
        read_data2_from_preg2 <= 0;
        instruction_from_preg2 <= 0;
    end
    else
    begin
        alu_result_from_preg2 <= result_from_alu_i;
        read_data1_from_preg2 <= read_data1_from_preg1_i;
        read_data2_from_preg2 <= read_data2_from_preg1_i;
        instruction_from_preg2 <= instruction_from_preg1_i;
    end
end

reg [4:0] rs1_from_EX_MEM;
reg [4:0] rs2_from_EX_MEM;
reg [4:0] rd_from_EX_MEM;
assign rs1_from_EX_MEM_o = rs1_from_EX_MEM;
assign rs2_from_EX_MEM_o = rs2_from_EX_MEM;
assign rd_from_EX_MEM_o  = rd_from_EX_MEM;

always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        rs1_from_EX_MEM <= 0;
        rs2_from_EX_MEM <= 0;
        rd_from_EX_MEM  <= 0;
    end
//    else if (lw_stall_i)
//    begin
//        rs1_from_EX_MEM <= rs1_from_EX_MEM;
//        rs2_from_EX_MEM <= rs2_from_EX_MEM;
//        rd_from_EX_MEM  <= rd_from_EX_MEM;
//    end
    else if (bjump_i)
    begin
        rs1_from_EX_MEM <= 0;
        rs2_from_EX_MEM <= 0;
        rd_from_EX_MEM  <= 0;
    end
    else
    begin
        rs1_from_EX_MEM <= rs1_from_ID_EX_i;
        rs2_from_EX_MEM <= rs2_from_ID_EX_i;
        rd_from_EX_MEM  <= rd_from_ID_EX_i;
    end
end

reg [31:0] pc_from_preg2;
reg [31:0] ext_from_preg2;
assign pc_from_preg2_o = pc_from_preg2;
assign ext_from_preg2_o = ext_from_preg2;
always @ (posedge clk_i)
begin
     if (~rst_n)
     begin
        pc_from_preg2 <= 32'hffff_fffc;
        ext_from_preg2 <= 0;
     end
//     else if (lw_stall_i)
//     begin
//        pc_from_preg2 <= pc_from_preg2;
//        ext_from_preg2 <= ext_from_preg2;
//     end
     else if (bjump_i)
     begin
        pc_from_preg2 <= 32'hffff_fffc;
        ext_from_preg2 <= 0;
     end
     else
     begin
        pc_from_preg2 <= pc_from_preg1_i;
        ext_from_preg2 <= ext_from_preg1_i;
     end
end

endmodule

