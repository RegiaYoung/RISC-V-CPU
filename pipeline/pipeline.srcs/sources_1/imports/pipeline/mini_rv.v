module mini_rv(
    input rst_n,
    input clk,
	output        debug_wb_have_inst,   
	output [31:0] debug_wb_pc,         
    output        debug_wb_ena,         
    output [4:0]  debug_wb_reg,         
    output [31:0] debug_wb_value,
    
    output [31:0] pc_from_pc_o,
    input  [31:0] instruction_from_irom,
    output [31:0] addr_i,
    output [31:0] rd_data_o,
    output memwr_i,
    output [31:0] wr_data_i
//    inst_mem U0_irom (
//    .a(pc_from_pc[15:2]),       // input wire [13:0] a
//    .spo(instruction_from_irom)           // output wire [31:0] spo
//    );
//data_mem U_dram (
//    .clk    (ram_clk),          // input wire clka
//    .a      (addr_i[15:2]),     // input wire [13:0] addra
//    .spo   (rd_data_o),        // output wire [31:0] douta
//    .we     (memwr_i),          // input wire [0:0] wea
//    .d      (wr_data_i)         // input wire [31:0] dina
//);

    
    );

wire [31:0] instruction;            // instrcution fetch from IROM
wire [1:0] cmp_result_from_branch;  // compare result from Branch_compare
wire [1:0] pc_sel;                        // pc select signal
wire [3:0] sext_sel;                // operation-select signal for Sign_Extent
wire RegWEn;                        // write-enable-signal for Reg_File
wire branch_sel;                    // branch_sel-signal from Control unit 1:jump, 0: do not jump
wire A_sel;                         // operand A-select signal for ALU; 0:data of reg1, 1:pc+4 
wire B_sel;                         // operand B-select signal for ALU; 0:data of reg2, 1:32 bits ext from extention
wire [3:0] ALU_sel;                 // operation-select signal for ALU
wire MemRW;                         // Data Memorty write-enable signal
wire [2:0] WBSel;                         // data select-signal for mux to choose data for write back oeprantion

wire [31:0] pc_plus_4;              // pc+4
wire [31:0] pc_from_pc;             // output from Program Counter
wire [31:0] pc_branch;              // address for B format operation
wire [31:0] pc_from_mux;                   // output from MUX for Program Counter



wire [31:0] data1_from_rf;          // data 1 from Reg File
wire [31:0] data2_from_rf;          // data 2 from Reg File
wire [31:0] write_back_data_from_mux4;// write back data from mux 3 for Reg File


wire [31:0] A_data_from_mux_a;      // operand A for ALU from MUX for A
wire [31:0] B_data_from_mux_b;      // operand B for ALU from MUX for B



wire [31:0] result_from_alu;        // calcultaion result from ALU







assign memwr_i = MemRW;


wire [31:0] ext_from_sext;          // extention result from Sign Extent

wire rst;

assign rst = ~rst_n;

wire [31:0] wb_data;
wire [31:0] write_to_mem;
// 64KB IROM
wire [31:0] instruction_to_pipereg1;


wire [31:0] instruction_from_preg0;
wire [31:0] pc_from_preg0;


wire [31:0] pc_from_preg1;
wire [31:0] pc_from_preg2;
wire [31:0] pc_from_preg3;
wire [31:0] read_data1_from_preg1;
wire [31:0] read_data2_from_preg1;
wire [31:0] ext_from_preg1;
wire [31:0] instruction_from_preg1;

wire [31:0] alu_result_from_preg2;
wire [31:0] read_data1_from_preg2;
wire [31:0] read_data2_from_preg2;
wire [31:0] instruction_from_preg2;

wire [31:0] read_data_from_preg3;
wire [31:0] alu_result_from_preg3;
wire [31:0] instruction_from_preg3;



wire [4:0] rs1_from_IF_ID;
wire [4:0] rs2_from_IF_ID;
wire [4:0] rd_from_IF_ID;
wire [4:0] rs1_from_ID_EX;
wire [4:0] rs2_from_ID_EX;
wire [4:0] rd_from_ID_EX;
wire [4:0] rs1_from_EX_MEM;
wire [4:0] rs2_from_EX_MEM;
wire [4:0] rd_from_EX_MEM;
wire [4:0] rs1_from_MEM_WB;
wire [4:0] rs2_from_MEM_WB;
wire [4:0] rd_from_MEM_WB;

wire [2:0] forwarding_A;
wire [2:0] forwarding_B;

wire lw_stall;
wire [31:0] instruction_before;
wire [31:0] ext_from_preg2;
wire [31:0] ext_from_preg3;

assign addr_i = alu_result_from_preg2;

wire [31:0] pc_from_preg3_plus_4;
reg have_inst;
assign debug_wb_have_inst = have_inst;
always @ (*)
begin
    if (instruction_from_preg3 == 0)
        have_inst = 0;
    else
        have_inst = 1;
end
assign debug_wb_pc = pc_from_preg3;
assign debug_wb_ena = RegWEn;
assign debug_wb_reg = instruction_from_preg3[11:7];
wire [31:0] wb_data_tmp;
assign debug_wb_value = wb_data;
assign pc_from_pc_o = pc_from_pc;
wire bjump;


// control logic
control_unit U_control_unit(
    .reset_i(rst),
    .clk_i(clk),
    .lw_stall_i(lw_stall),
    .instruction_i(instruction_from_irom),
    .bjump_i(bjump),
    .instruction_from_preg0_i(instruction_from_preg0),
    .instruction_from_preg1_i(instruction_from_preg1),
    .instruction_from_preg2_i(instruction_from_preg2),
    .instruction_from_preg3_i(instruction_from_preg3),
    
    .pc_sel_o(pc_sel),                                  // output wire pc mux select signal
    .sext_sel_o(sext_sel),                              // output wire [3:0] sext select signal
    .RegWEn_o(RegWEn),                                  // output wire reg file write enable signal
    .A_sel_o(A_sel),                                    // output wire A mux select signal
    .B_sel_o(B_sel),                                    // output wire B mux selext signal
    .ALU_sel_o(ALU_sel),                                // output wire [3:0] ALU operation select signal
    .MemRW_o(MemRW),                                    // output wire data memory write enable signal
    .WBSel_o(WBSel)                                     // output wire [1:0] write back mux selext signal
);

// forwarding unit
wire [2:0] alu_forwarding;
wire [2:0] sw_forwarding;
forwarding_unit U_forwarding_unit(
     .rst_n(rst_n),
     .clk_i(clk),
     .instruction_from_preg3_i(instruction_from_preg3),
     .instruction_from_preg2_i(instruction_from_preg2),
     .instruction_from_preg1_i(instruction_from_preg1),
     .instruction_before_i(instruction_before),
     .rd_before_i(instruction_from_preg3[11:7]),
     .reg_wen_before_i(RegWEn), 
     .A_sel_i(A_sel),
     .B_sel_i(B_sel),
     .rs1_from_ID_EX_i(rs1_from_ID_EX),
     .rs2_from_ID_EX_i(rs2_from_ID_EX),
     .rd_from_EX_MEM_i(rd_from_EX_MEM),
     .rd_from_MEM_WB_i(rd_from_MEM_WB),
     .forwarding_A_o(forwarding_A),
     .forwarding_B_o(forwarding_B),
     .sw_forwarding_B_o(sw_forwarding)
    );
// hazard detection unit
hazard_detection_unit U_hazard_detection_unit(
     .rst_n(rst_n),
     .clk_i(clk),
     .instruction_from_preg1_i(instruction_from_preg1),
     .rd_from_ID_EX_i(rd_from_ID_EX),
     .rs1_from_IF_ID_i(rs1_from_IF_ID),
     .rs2_from_IF_ID_i(rs2_from_IF_ID),
     .lw_stall_o(lw_stall)
    );

reg_for_inst_before_LW U_reg_for_inst_before_LW(
    .rst_n(rst_n),
    .clk_i(clk),
    .instruction_from_preg3_i(instruction_from_preg3),
    .instruction_before_o(instruction_before)
    );

//wire tmp;
//wire [31:0] branch_tmp;
//branch_prediction U_branch_prediction (
//    .rst_n(rst_n),
//    .instruction_from_preg0_i(instruction_from_preg0),
//    .read_data1_from_rf_i(data1_from_rf),
//    .read_data2_from_rf_i(data2_from_rf),
//    .pc_from_pc_i(pc_from_pc),
//    .offset_i(ext_from_sext),
//    .bjump_o(tmp),
//    .pc_branch_o(branch_tmp)
//    );

wire [31:0] cmp_value1;
wire [31:0] cmp_value2;
wire [31:0] wb_value_before;
branch_reg_select U_branch_reg_select (
    .rst_n(rst_n),
    .clk_i(clk),
    .instruction_from_preg2_i(instruction_from_preg2),
    .read_data1_from_preg2_i(read_data1_from_preg2),
    .read_data2_from_preg2_i(read_data2_from_preg2),
    
    .reg_wen_before_i(RegWEn),
    .wb_value_before_i(wb_data),
    .rd_before_i(instruction_from_preg3[11:7]),
    
    .cmp_value1_o(cmp_value1),
    .cmp_value2_o(cmp_value2),
    .wb_value_before_o(wb_value_before)
    );

control_hazard U_control_hazard (
    .rst_n(rst_n),
    .clk_i(clk),
    .instruction_from_preg2_i(instruction_from_preg2),
    .cmp_value1_i(cmp_value1),
    .cmp_value2_i(cmp_value2),
    
    .bjump_o(bjump)
    );



// all components
// PC
// mux to select next pc value
assign pc_branch = alu_result_from_preg2;
mux_3 U_mux_3_0(
    .select_signal(pc_sel),     // input wire pc select signal
    .input0(pc_plus_4),         // input wire [31:0] pc+4
    .input1(pc_branch),
    .input2(result_from_alu),
    .output_data(pc_from_mux)   // output wire [31:0] pc from MUX
    );
program_counter U_program_counter(
    .clk_i(clk),                // input wire clk
    .reset_i(rst),              // input wire reset
    .stall_i(lw_stall),
    .next_pc_i(pc_from_mux),    // input wire [31:0] pc from MUX
    .pc_o(pc_from_pc)           // output wire [31:0] pc for IROM
    );
adder_for_plus_4 U_adder_for_pc_plus_4(
    .pc_from_pc_i(pc_from_pc),  // input wire [31:0] pc to add 4
    .pc_plus_4_o(pc_plus_4)     // output wire [31:0] pc+4
    );


wire jstall;
j_format_stall U_j_format_stall (
    .rst_n(rst_n),
    .bstall_i(bjump),
    .clk_i(clk),
    .instruction_from_preg1_i(instruction_from_preg1),
    .instruction_from_preg0_i(instruction_from_preg0),
    .jstall_o(jstall)
    );

//wire [31:0] jal_wb_value;
//adder_for_jal U_adder_for_jal(
//    .pc_from_pc_i(pc_from_pc),
//    .instruction_from_irom_i(instruction_from_irom),
//    .pc_for_jal_o(pc_for_jal),
//    .jal_wb_value_o(jal_wb_value)
//    );

pipeline_reg0 U_pipeline_reg0(
     .clk_i(clk),
     .rst_n(rst_n),
     .bjump_i(pc_sel[0]),
     .lw_stall_i(lw_stall),
     .jstall_i(jstall),
     .pc_from_pc_i(pc_from_pc),
     .instruction_from_irom_i(instruction_from_irom),
     .pc_from_preg0_o(pc_from_preg0),
     .instruction_from_preg0_o(instruction_from_preg0),
     .rs1_from_IF_ID_o(rs1_from_IF_ID),
     .rs2_from_IF_ID_o(rs2_from_IF_ID),
     .rd_from_IF_ID_o(rd_from_IF_ID)
    );

//mux_2 U_jal_mux_2(
//    .select_signal(pc_sel[1]),
//    .input0(wb_data),
//    .input1(jal_wb_value),
//    .output_data(wb_data_tmp)
//    );

// reg file
reg_file U_reg_file(
    .clk_i(clk),              // input wire clk
    .rR1_i(instruction_from_preg0[19:15]), // input wire [4:0] resourse register1
    .rR2_i(instruction_from_preg0[24:20]),  // input wire [4:0] resourse register2
    .wR_i(instruction_from_preg3[11:7]),   // input wire [4:0] destination register
    .WE_i(RegWEn),      // input wire write-enable signal of register
    .wD_i(wb_data), // input wire [31:0] write back data from mux4
    .rD1_o(data1_from_rf),      // output wire [31:0] data1 from reg file
    .rD2_o(data2_from_rf)       // output wire [31:0] data2 from reg file
    );

sign_extention U_sign_extention(
    .instruction_i(instruction_from_preg0),        // input wire [31:0] instruction
    .sext_sel_i(sext_sel),              // input wire [4:0]  sign-extention-operantion-select signal
    .ext_from_sext_o(ext_from_sext)     // extention result from Sign Extention
    );


pipeline_reg1 U_pipeline_reg1(
	.clk_i(clk),
	.rst_n(rst_n),
	.bjump_i(bjump),
	.lw_stall_i(lw_stall),
	.pc_from_preg0_i(pc_from_preg0),
	.read_data1_from_rf_i(data1_from_rf),
	.read_data2_from_rf_i(data2_from_rf),
	.instruction_from_preg0_i(instruction_from_preg0),
	.ext_from_sext_i(ext_from_sext),
	.pc_from_preg1_o(pc_from_preg1),
	.read_data1_from_preg1_o(read_data1_from_preg1),
	.read_data2_from_preg1_o(read_data2_from_preg1),
	.ext_from_preg1_o(ext_from_preg1),
	.instruction_from_preg1_o(instruction_from_preg1),
	
	.rs1_from_IF_ID_i(rs1_from_IF_ID),
	.rs2_from_IF_ID_i(rs2_from_IF_ID),
	.rd_from_IF_ID_i(rd_from_IF_ID),
	.rs1_from_ID_EX_o(rs1_from_ID_EX),
    .rs2_from_ID_EX_o(rs2_from_ID_EX),
    .rd_from_ID_EX_o(rd_from_ID_EX)
    );

// MUXs beteen Reg File and ALU
reg [31:0] zero = 0;
mux_7 U_mux_7_a(
    .select_signal(forwarding_A),           // input wire MUX signal for Data_A for ALU
    .input0(read_data1_from_preg1),         // input wire [31:0] data1 from reg file
    .input1(pc_from_preg1),                 // input wire [31:0] pc+4
    .input2(alu_result_from_preg2),
    .input3(alu_result_from_preg3),
    .input4(read_data_from_preg3),
    .input5(wb_value_before),
    .input6(zero),
    .output_data(A_data_from_mux_a)         // output wire [31:0] Data_A for ALU
    );
mux_6 U_mux_6_b(
    .select_signal(forwarding_B),                  // input wire MUX signal for Data_B for ALU
    .input0(read_data2_from_preg1),         // input wire [31:0] data2 from reg file
    .input1(ext_from_preg1),                // input wire [31:0] extention result from sign_extention
    .input2(alu_result_from_preg2),
    .input3(alu_result_from_preg3),
    .input4(read_data_from_preg3),
    .input5(wb_value_before),
    .output_data(B_data_from_mux_b)         // output wire [31:0] Data_B for ALU
    );

// ALU
algorithm_logic_unit U_algorithm_unit(
    .operand_A_i(A_data_from_mux_a),    // input [31:0] operand A
    .operand_B_i(B_data_from_mux_b),    // input [31:0] operand B
    .op_sel_i(ALU_sel),              // input [2:0] ALU operation select signal
    .result_from_alu_o(result_from_alu) // output [31:0] result from ALU
    );


pipeline_reg2 U_pipeline_reg2 (
	.clk_i(clk),
	.rst_n(rst_n),
	.bjump_i(bjump),
	.lw_stall_i(lw_stall),
	.result_from_alu_i(result_from_alu),
	.read_data1_from_preg1_i(read_data1_from_preg1),
	.read_data2_from_preg1_i(read_data2_from_preg1),
	.instruction_from_preg1_i(instruction_from_preg1),
	
	.pc_from_preg1_i(pc_from_preg1),
	.ext_from_preg1_i(ext_from_preg1),
	
	.alu_result_from_preg2_o(alu_result_from_preg2),
	.read_data1_from_preg2_o(read_data1_from_preg2),
	.read_data2_from_preg2_o(read_data2_from_preg2),
	.instruction_from_preg2_o(instruction_from_preg2),
	
	.rs1_from_ID_EX_i(rs1_from_ID_EX),
	.rs2_from_ID_EX_i(rs2_from_ID_EX),
	.rd_from_ID_EX_i(rd_from_ID_EX),
	.rs1_from_EX_MEM_o(rs1_from_EX_MEM),
    .rs2_from_EX_MEM_o(rs2_from_EX_MEM),
    .rd_from_EX_MEM_o(rd_from_EX_MEM),
    
    .pc_from_preg2_o(pc_from_preg2),
    .ext_from_preg2_o(ext_from_preg2)
    );

// branch compare
branch_compare U_branch_compare(
    .data1_from_rf_i(read_data1_from_preg2),    // input wire [31:0] data 1 from Reg File
    .data2_from_rf_i(read_data2_from_preg2),    // input wire [31:0] data 2 from Reg File
    .func3(instruction_from_preg2[14:12]),
    .cmp_result_from_branch_o(cmp_result_from_branch)// output wire [1:0] compare result from branch_cmp
    );


wire [31:0] wb_value_3;
wire [31:0] wb_value_2;
wire [31:0] wb_value_1;
wire [31:0] wb_value_0;
wb_value_recorder U_wb_value_recorder (
    .rst_n(rst_n),
    .clk_i(clk),
    .wb_value_i(debug_wb_value),
    .wb_value_3_o(wb_value_3),
    .wb_value_2_o(wb_value_2),
    .wb_value_1_o(wb_value_1),
    .wb_value_0_o(wb_value_0)
    );

// 64KB DRAM
wire [31:0] forwarding_write_to_mem;
mux_6 U_mux_6(
    .select_signal(sw_forwarding),                  // input wire MUX signal for Data_B for ALU
    .input0(read_data2_from_preg2),         // input wire [31:0] data2 from reg file
    .input1(read_data2_from_preg2),                // input wire [31:0] extention result from sign_extention
    .input2(alu_result_from_preg3),
    .input3(wb_value_before),
    .input4(wb_value_1),
    .input5(wb_value_2),
    .output_data(forwarding_write_to_mem)         // output wire [31:0] Data_B for ALU
    );

sl_sh_unit U_sl_sh_unit(
    .instruction_i(instruction_from_preg2),
    .addr_i(addr_i[1:0]),
    .data_from_mem(rd_data_o),
    .data2_from_rf(forwarding_write_to_mem),
    .wr_data_o(wr_data_i)
    );
    



pipeline_reg3 U_pipeline_reg3 (
	.clk_i(clk),
	.rst_n(rst_n),
	.lw_stall_i(lw_stall),
	.read_data_from_dram_i(rd_data_o),
	.alu_result_from_preg2_i(alu_result_from_preg2),
	.instruction_from_preg2_i(instruction_from_preg2),
	
	.pc_from_preg2_i(pc_from_preg2),
	.ext_from_preg2_i(ext_from_preg2),
	
	.read_data_from_preg3_o(read_data_from_preg3),
	.alu_result_from_preg3_o(alu_result_from_preg3),
	.instruction_from_preg3_o(instruction_from_preg3),
	
	.rs1_from_EX_MEM_i(rs1_from_EX_MEM),
	.rs2_from_EX_MEM_i(rs2_from_EX_MEM),
	.rd_from_EX_MEM_i(rd_from_EX_MEM),
	.rs1_from_MEM_WB_o(rs1_from_MEM_WB),
    .rs2_from_MEM_WB_o(rs2_from_MEM_WB),
    .rd_from_MEM_WB_o(rd_from_MEM_WB),
    
    .pc_from_preg3_o(pc_from_preg3),
    .ext_from_preg3_o(ext_from_preg3)
    );


adder_for_plus_4 U_adder_for_wb_pc_plus_4(
    .pc_from_pc_i(pc_from_preg3),  // input wire [31:0] pc to add 4
    .pc_plus_4_o(pc_from_preg3_plus_4)     // output wire [31:0] pc+4
    );
// MUX_4 for write back
mux_5 U_mux_5(
    .select_signal(WBSel),              // input wire [1:0] select signal for mux for write back
    .input0(alu_result_from_preg3),     // input wire [31:0] result from alu
    .input1(read_data_from_preg3),                 // input wire [31:0] data from data memory
    .input2(pc_from_preg3_plus_4),                 // input wire [31:0] pc+4
    .input3(ext_from_preg3),            // input wire [31:0] extention result from Sign Extension
    .input4(alu_result_from_preg2),
    .output_data(write_back_data_from_mux4) // output wire [31:0] data from mux3 to write back to reg file
    );

lb_lh_unit U_lb_lh_unit(
    .instruction_i(instruction_from_preg3),
    .addr_i(alu_result_from_preg3[1:0]),
    .write_back_data_from_mux4(write_back_data_from_mux4),
    .wb_data_o(wb_data)
    );


endmodule






