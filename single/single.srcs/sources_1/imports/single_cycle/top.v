module top(
    input rst_n,
    input clk,
	output        debug_wb_have_inst,   // WB闂傚倸鍟抽崺鏍敊瀹�鍕強妞ゆ牗纰嶉崕濠囨煛閸繍妲归悗鍨缁傛帡鏁�? (闁诲海鏁搁幊鎾崇暦閻旂厧宸濋柕濠忛檮閸╀景PU闂佹寧绋戦張顒勵敆濠曠劄ag闂佽鍘界敮濠勬嫻?1)
    output [31:0] debug_wb_pc,          // WB闂傚倸鍟抽崺鏍敊瀹�鍕剭闁告垹娉� (闂佸吋妞垮▍顪╛have_inst=0闂佹寧绋戦張顒勵敆濠靛洢浜滈柣鐔告緲鐠佹彃鈽夐幘瑙勩�冮柟骞垮灲楠炲洩绠涢幙鍕闁匡拷?)
    output        debug_wb_ena,         // WB闂傚倸鍟抽崺鏍敊瀹�鍕剭闁告洦鍋嗗Σ鎴︽倵濞戞顏勨枍閹烘绀冩繛鍡楅閳诲繘鏌ょ粵瑙勫 (闂佸吋妞垮▍顪╛have_inst=0闂佹寧绋戦張顒勵敆濠靛洢浜滈柣鐔告緲鐠佹彃鈽夐幘瑙勩�冮柟骞垮灲楠炲洩绠涢幙鍕闁匡拷?)
    output [4:0]  debug_wb_reg,         // WB闂傚倸鍟抽崺鏍敊瀹�鍕婵炲棗绻愬鎶芥煟閵娿儱顏╅柣锕�娴�?濞戞顏勨枍閹烘鐭楅柨锟�? (闂佸吋妞垮▍顪╛ena闂佺懓鐡ㄥ绂竉have_inst=0闂佹寧绋戦張顒勵敆濠靛洢浜滈柣鐔告緲鐠佹彃鈽夐幘瑙勩�冮柟骞垮灲楠炲洩绠涢幙鍕闁匡拷?)
    output [31:0] debug_wb_value        // WB闂傚倸鍟抽崺鏍敊瀹�鍕婵炲棗绻愬鎶芥倵闂堟稑顏╅柣掳鍔戝畷鎶藉Ω瑜庨悾閬嶆煕婵犲繑瀚� (闂佸吋妞垮▍顪╛ena闂佺懓鐡ㄥ绂竉have_inst=0闂佹寧绋戦張顒勵敆濠靛洢浜滈柣鐔告緲鐠佹彃鈽夐幘瑙勩�冮柟骞垮灲楠炲洩绠涢幙鍕闁匡拷?)
    );





wire [31:0] instruction;            // instrcution fetch from IROM
wire [1:0] cmp_result_from_branch;  // compare result from Branch_compare
wire pc_sel;                        // pc select signal
wire [3:0] sext_sel;                // operation-select signal for Sign_Extent
wire RegWEn;                        // write-enable-signal for Reg_File
wire branch_sel;                    // branch_sel-signal from Control unit 1:jump, 0: do not jump
wire A_sel;                         // operand A-select signal for ALU; 0:data of reg1, 1:pc+4 
wire B_sel;                         // operand B-select signal for ALU; 0:data of reg2, 1:32 bits ext from extention
wire [3:0] ALU_sel;                 // operation-select signal for ALU
wire MemRW;                         // Data Memorty write-enable signal
wire [1:0] WBSel;                         // data select-signal for mux to choose data for write back oeprantion

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
assign pc_branch = result_from_alu; // address for B format instruction to jump to


wire [31:0] addr_i;                 // address for Data RAM
wire [31:0] wr_data_i;              // data for Data RAM to write
wire ram_clk;                       // reverse clk for Data RAM
wire [31:0] rd_data_o;              // output data from Data RAM
assign ram_clk = !clk;

assign addr_i = result_from_alu;

assign memwr_i = MemRW;


wire [31:0] ext_from_sext;          // extention result from Sign Extent

wire rst;

assign rst = ~rst_n;

wire [31:0] wb_data;
wire [31:0] write_to_mem;
// 64KB IROM
inst_mem U0_irom (
    .a(pc_from_pc[15:2]),       // input wire [13:0] a
    .spo(instruction)           // output wire [31:0] spo
    );
// control logic
control_unit U_control_unit(
    .reset_i(rst),
    .instruction_i(instruction),
    .cmp_result_from_branch_i(cmp_result_from_branch),  // input wire [1:0] compare result from branch_cmp
    .pc_sel_o(pc_sel),                                  // output wire pc mux select signal
    .sext_sel_o(sext_sel),                              // output wire [3:0] sext select signal
    .RegWEn_o(RegWEn),                                  // output wire reg file write enable signal
    .branch_sel_o(branch_sel),                          // output wire branch select signal
    .A_sel_o(A_sel),                                    // output wire A mux select signal
    .B_sel_o(B_sel),                                    // output wire B mux selext signal
    .ALU_sel_o(ALU_sel),                                // output wire [3:0] ALU operation select signal
    .MemRW_o(MemRW),                                    // output wire data memory write enable signal
    .WBSel_o(WBSel)                                     // output wire [1:0] write back mux selext signal
);

assign debug_wb_have_inst = 1;
assign debug_wb_pc = pc_from_pc;
assign debug_wb_ena = RegWEn;
assign debug_wb_reg = instruction[11:7];
assign debug_wb_value = wb_data;
// all components
// PC
// mux to select next pc value
mux_2 U_mux_2_0(
    .select_signal(pc_sel),     // input wire pc select signal
    .input0(pc_plus_4),         // input wire [31:0] pc+4
    .input1(pc_branch),         // input wire [31:0] branch address
    .output_data(pc_from_mux)   // output wire [31:0] pc from MUX
    );
program_counter U_program_counter(
    .clk_i(clk),              // input wire clk
    .reset_i(rst),          // input wire reset
    .next_pc_i(pc_from_mux),    // input wire [31:0] pc from MUX
    .pc_o(pc_from_pc)           // output wire [31:0] pc for IROM
    );
adder_for_plus_4 U_adder_for_pc_plus_4(
    .pc_from_pc_i(pc_from_pc),  // input wire [31:0] pc to add 4
    .pc_plus_4_o(pc_plus_4)     // output wire [31:0] pc+4
    );



// reg file
reg_file U_reg_file(
    .clk_i(clk),              // input wire clk
    .rR1_i(instruction[19:15]), // input wire [4:0] resourse register1
    .rR2_i(instruction[24:20]),  // input wire [4:0] resourse register2
    .wR_i(instruction[11:7]),   // input wire [4:0] destination register
    .WE_i(RegWEn),      // input wire write-enable signal of register
    .wD_i(wb_data), // input wire [31:0] write back data from mux3
    .rD1_o(data1_from_rf),      // output wire [31:0] data1 from reg file
    .rD2_o(data2_from_rf)       // output wire [31:0] data2 from reg file
    );

  

// branch compare
branch_compare U_branch_compare(
    .data1_from_rf_i(data1_from_rf),    // input wire [31:0] data 1 from Reg File
    .data2_from_rf_i(data2_from_rf),    // input wire [31:0] data 2 from Reg File
    .func3(instruction[14:12]),
    .cmp_result_from_branch_o(cmp_result_from_branch)// output wire [1:0] compare result from branch_cmp
    );


// MUXs beteen Reg File and ALU
mux_2 U_mux_2_a(
    .select_signal(A_sel),          // input wire MUX signal for Data_A for ALU
    .input0(data1_from_rf),         // input wire [31:0] data1 from reg file
    .input1(pc_from_pc),             // input wire [31:0] pc+4
    .output_data(A_data_from_mux_a) // output wire [31:0] Data_A for ALU
    );
mux_2 U_mux_2_b(
    .select_signal(B_sel),          // input wire MUX signal for Data_B for ALU
    .input0(data2_from_rf),         // input wire [31:0] data2 from reg file
    .input1(ext_from_sext),         // input wire [31:0] extention result from sign_extention
    .output_data(B_data_from_mux_b) // output wire [31:0] Data_B for ALU
    );

// ALU
algorithm_logic_unit U_algorithm_unit(
    .operand_A_i(A_data_from_mux_a),    // input [31:0] operand A
    .operand_B_i(B_data_from_mux_b),    // input [31:0] operand B
    .op_sel_i(ALU_sel),              // input [2:0] ALU operation select signal
    .result_from_alu_o(result_from_alu) // output [31:0] result from ALU
    );

// 64KB DRAM

wire mem_wen;
reg mem_wen_reg;
always @ (*)
begin
    if ((instruction[14:12] == 3'b000 || instruction[14:12] == 3'b001) && instruction[6:2] == 5'b01000)
        mem_wen_reg = mem_wen;
    else
        mem_wen_reg = memwr_i;
end
sl_sh_unit U_sl_sh_unit(
    .instruction_i(instruction),
    .addr_i(addr_i[1:0]),
    .data_from_mem(rd_data_o),
    .data2_from_rf(data2_from_rf),
    .wr_data_o(wr_data_i)
    );
data_mem U_dram (
    .clk    (ram_clk),          // input wire clka
    .a      (addr_i[15:2]),     // input wire [13:0] addra
    .spo   (rd_data_o),        // output wire [31:0] douta
    .we     (memwr_i),          // input wire [0:0] wea
    .d      (wr_data_i)         // input wire [31:0] dina
);


// MUX_4 for write back

mux_4 U_mux_4(
    .select_signal(WBSel),      // input wire [1:0] select signal for mux for write back
    .input0(result_from_alu),   // input wire [31:0] result from alu
    .input1(rd_data_o),         // input wire [31:0] data from data memory
    .input2(pc_plus_4),          // input wire [31:0] pc+4
    .input3(ext_from_sext),     // input wire [31:0] extention result from Sign Extension
    .output_data(write_back_data_from_mux4) // output wire [31:0] data from mux3 to write back to reg file
    );

lb_lh_unit U_lb_lh_unit(
    .instruction_i(instruction),
    .addr_i(addr_i[1:0]),
    .write_back_data_from_mux4(write_back_data_from_mux4),
    .wb_data_o(wb_data)
    );

sign_extention U_sign_extention(
    .instruction_i(instruction),        // input wire [31:0] instruction
    .sext_sel_i(sext_sel),              // input wire [4:0]  sign-extention-operantion-select signal
    .ext_from_sext_o(ext_from_sext)     // extention result from Sign Extention
    );


endmodule


