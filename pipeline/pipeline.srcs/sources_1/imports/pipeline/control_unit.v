module control_unit(
    input reset_i,
    input clk_i,
    input lw_stall_i,
    input [31:0] instruction_i,
    input bjump_i,
    
    input [31:0] instruction_from_preg0_i,
    input [31:0] instruction_from_preg1_i,
    input [31:0] instruction_from_preg2_i,
    input [31:0] instruction_from_preg3_i,
    
    output [1:0] pc_sel_o,
    output [3:0] sext_sel_o,
    output RegWEn_o,
    output A_sel_o,
    output B_sel_o,
    output [3:0] ALU_sel_o,
    output MemRW_o,
    output [2:0] WBSel_o
    );

wire instruction_30;
wire [2:0] instruction_14_to_12;
wire [4:0] instruction_6_to_2;
assign instruction_30 = instruction_i[30];
assign instruction_14_to_12 = instruction_i[14:12];
assign instruction_6_to_2 = instruction_i[6:2];

// sign extention signal
parameter [2:0] I = 3'b001;
parameter [2:0] S = 3'b010;
parameter [2:0] B = 3'b011;
parameter [2:0] J = 3'b100;
parameter [2:0] U = 3'b101;
reg [2:0] sext_sel;
assign sext_sel_o = sext_sel;
always @ (*)
begin
    if (reset_i)
        sext_sel = 0;
    else
    begin
        case(instruction_from_preg0_i[6:2])
            5'b00000:   sext_sel = I;
            5'b00011:   sext_sel = I;
            5'b00100:   sext_sel = I;
            5'b00110:   sext_sel = I;
            5'b01000:   sext_sel = S;
            5'b11000:   sext_sel = B;
	        5'b11001:	sext_sel = I;
            5'b11011:   sext_sel = J;
            5'b01101:   sext_sel = U;   // lui
            5'b00101:   sext_sel = U;   // auipc
            default:    sext_sel = 0;
        endcase
    end
end

// Regfile write enable
reg RegWEn;
assign RegWEn_o = RegWEn;
always @ (*)
begin
    if (reset_i)
        RegWEn = 0;
    else if (instruction_from_preg3_i[6:2] == 5'b11001 && instruction_from_preg3_i[14:12] == 3'b000)
        RegWEn = 1;
    else if (instruction_from_preg3_i[1:0] == 2'b11)
    begin
        case(instruction_from_preg3_i[6:2])
            5'b01100:   RegWEn = 1;
            5'b00000:   RegWEn = 1;
            5'b00011:   RegWEn = 1;
            5'b00100:   RegWEn = 1;
            5'b00110:   RegWEn = 1;
            5'b11011:   RegWEn = 1;
            5'b00101:   RegWEn = 1; // auipc
            5'b01101:   RegWEn = 1; // lui
            default:    RegWEn = 0;
        endcase
    end
end


reg [1:0] pc_sel;
assign pc_sel_o = pc_sel;
always @ (*)
begin
    if (reset_i)
        pc_sel = 0;
    else if (bjump_i)
	pc_sel = 2'b01;
    else if (instruction_from_preg1_i[6:2] == 5'b11011)    // j format
        pc_sel = 2'b10;
    else if (instruction_from_preg1_i[6:2] == 5'b11001)
	    pc_sel = 2'b10;
    else
    begin
        pc_sel[1] = 2'b0;
        pc_sel[0] = bjump_i;
    end
end

// mux A and mux B sel
reg A_sel_tmp;
assign A_sel_o = A_sel_tmp;
always @ (*)
begin
    if (instruction_from_preg1_i[6:2] == 5'b11001) A_sel_tmp = 0;
    else if (instruction_from_preg1_i[6:2] == 5'b00101)   A_sel_tmp = 1;  // auipc
    else if (instruction_from_preg1_i[6:2] == 5'b11011)   A_sel_tmp = 1;  // J format
    else if (instruction_from_preg1_i[6:2] == 5'b11000)   A_sel_tmp = 1;  // B format
    else                                                  A_sel_tmp = 0;
end
reg B_sel;
assign B_sel_o = B_sel;
always @ (*)
begin
    if (reset_i)                                B_sel = 0;
    else if (instruction_from_preg1_i[6:2] == 5'b01100)    B_sel = 0;    // R format
    else                                        B_sel = 1;
end

// ALU select logic

wire [8:0] bits_of_instruction_from_preg1;
assign bits_of_instruction_from_preg1[8] = instruction_from_preg1_i[30];
assign bits_of_instruction_from_preg1[7:5] = instruction_from_preg1_i[14:12];
assign bits_of_instruction_from_preg1[4:0] = instruction_from_preg1_i[6:2];
reg [3:0] ALU_sel;
assign ALU_sel_o = ALU_sel;
always @ (*)
begin
    if (reset_i)
        ALU_sel = 0;
    else if (bits_of_instruction_from_preg1 == 9'b1_000_01100)
        ALU_sel = `SUB;
    else if (bits_of_instruction_from_preg1 == 9'b0_111_01100 || bits_of_instruction_from_preg1[7:0] == 8'b111_00100)
        ALU_sel = `AND;
    else if (bits_of_instruction_from_preg1 == 9'b0_110_01100 || bits_of_instruction_from_preg1[7:0] == 8'b110_00100)
        ALU_sel = `OR;
    else if (bits_of_instruction_from_preg1 == 9'b0_100_01100 || bits_of_instruction_from_preg1[7:0] == 8'b100_00100)
        ALU_sel = `XOR;
    else if (bits_of_instruction_from_preg1 == 9'b0_001_01100 || bits_of_instruction_from_preg1[7:0] == 8'b001_00100)
        ALU_sel = `SLL;
    else if (bits_of_instruction_from_preg1 == 9'b0_101_01100 || bits_of_instruction_from_preg1 == 9'b0_101_00100)
        ALU_sel = `SRL;
    else if (bits_of_instruction_from_preg1 == 9'b1_101_01100 || bits_of_instruction_from_preg1 == 9'b1_101_00100)
        ALU_sel = `SRA;
    else if (bits_of_instruction_from_preg1 == 9'b0_010_01100)
        ALU_sel = `SLT;
    else if (bits_of_instruction_from_preg1 == 9'b0_011_01100)
        ALU_sel = `SLTU;
    else if (instruction_from_preg1_i[14:12] == 3'b010 && instruction_from_preg1_i[6:2] == 5'b00100)
        ALU_sel = `SLTI;
    else if (instruction_from_preg1_i[14:12] == 3'b011 && instruction_from_preg1_i[6:2] == 5'b00100)
        ALU_sel = `SLTIU;
    else
        ALU_sel = `ADD;
end



// Mem write enable
reg MemRW;
assign MemRW_o = MemRW;
always @ (*)
begin
    if (reset_i)                            MemRW = 0;
    else if (instruction_from_preg2_i[6:2] == 5'b01000)   MemRW = 1;  // S format
    else                                    MemRW = 0;
end


// WB sel
reg [2:0] delay;
always @ (posedge clk_i)
begin
    if (reset_i)
        delay <= 0;
    else if (lw_stall_i)
        delay <= delay + 1;
    else if (delay != 0)
        delay <= delay + 1;
    else
        delay <= 0;
end
reg [2:0] WBSel;
assign WBSel_o = WBSel;
always @ (*)
begin
    if (reset_i)                                           WBSel = 0;
    else if (instruction_from_preg3_i[6:2] == 5'b11011)    WBSel = 3'b010;      // jal
    else if (instruction_from_preg3_i[6:2] == 5'b11001)	   WBSel = 3'b010;
    else if (instruction_from_preg3_i[6:2] == 5'b00000)    WBSel = 3'b001;      // load instruction
    else if (instruction_from_preg3_i[6:2] == 5'b01101)    WBSel = 3'b011;      // lui
    else if (instruction_from_preg3_i[6:2] == 5'b00101)    WBSel = 3'b000;      // auipc
    else                                                   WBSel = 3'b000;
end

endmodule


