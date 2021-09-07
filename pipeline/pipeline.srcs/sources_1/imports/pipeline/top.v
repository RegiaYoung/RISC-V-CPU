module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,   
	output [31:0] debug_wb_pc,         
    output        debug_wb_ena,         
    output [4:0]  debug_wb_reg,         
    output [31:0] debug_wb_value

    );

wire [31:0] pc_from_pc;
wire [31:0] instruction_from_irom;
wire [31:0] addr_i;
wire [31:0] rd_data_o;
wire mem_wr_i;
wire [31:0] wr_data_i;

inst_mem U0_irom (
    .a(pc_from_pc[15:2]),       // input wire [13:0] a
    .spo(instruction_from_irom)           // output wire [31:0] spo
    );

wire ram_clk;                       // reverse clk for Data RAM
assign ram_clk = !clk;
data_mem U_dram (
    .clk    (ram_clk),          // input wire clka
    .a      (addr_i[15:2]),     // input wire [13:0] addra
    .spo   (rd_data_o),        // output wire [31:0] douta
    .we     (memwr_i),          // input wire [0:0] wea
    .d      (wr_data_i)         // input wire [31:0] dina
);

mini_rv U_mini_rv(
    .rst_n(rst_n),
    .clk(clk),
	.debug_wb_have_inst(debug_wb_have_inst),   
	.debug_wb_pc(debug_wb_pc),         
    .debug_wb_ena(debug_wb_ena),         
    .debug_wb_reg(debug_wb_reg),         
    .debug_wb_value(debug_wb_value),
    
    
    .pc_from_pc_o(pc_from_pc),
    .instruction_from_irom(instruction_from_irom),
    .addr_i(addr_i),
    .rd_data_o(rd_data_o),
    .memwr_i(memwr_i),
    .wr_data_i(wr_data_i)
             
    );
endmodule

