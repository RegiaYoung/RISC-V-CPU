

module control_unit(
    input reset_i,
    input [31:0] instruction_i,
    input [1:0] cmp_result_from_branch_i,
    output pc_sel_o,
    output [3:0] sext_sel_o,
    output RegWEn_o,
    output branch_sel_o,
    output A_sel_o,
    output B_sel_o,
    output [3:0] ALU_sel_o,
    output MemRW_o,
    output [1:0] WBSel_o
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
        case(instruction_6_to_2)
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
    else if (instruction_i[6:2] == 5'b11001 && instruction_i[14:12] == 3'b000)
        RegWEn = 1;
    else
    begin
        case(instruction_6_to_2)
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

// branch control logic
reg branch_sel;
reg pc_sel;
assign pc_sel_o = pc_sel;
assign branch_sel_o = branch_sel;
always @ (*)
begin
    if (reset_i)
        branch_sel = 0;
    else if(instruction_6_to_2[4:0] == 5'b11000)
    begin
        if (instruction_14_to_12 == 3'b000 && cmp_result_from_branch_i == 2'b00) // beq
            branch_sel = 1;
        else if (instruction_14_to_12 == 3'b001 && cmp_result_from_branch_i != 2'b00) // bne
            branch_sel = 1;
        else if (instruction_14_to_12 == 3'b100 && cmp_result_from_branch_i == 2'b10) // blt
            branch_sel = 1;
        else if (instruction_14_to_12 == 3'b101 && cmp_result_from_branch_i < 2) // bge
            branch_sel = 1;
        else if (instruction_14_to_12 == 3'b110 && cmp_result_from_branch_i == 2'b10) // bltu
            branch_sel = 1;
        else if (instruction_14_to_12 == 3'b111 && cmp_result_from_branch_i == 2'b01) // bgeu
            branch_sel = 1;
        else
            branch_sel = 0;
    end
    else
        branch_sel = 0;
end

always @ (*)
begin
    if (reset_i)
        pc_sel = 0;
    else if (instruction_i[6:2] == 5'b11011)    // j format
        pc_sel = 1;
    else if (instruction_i[6:2] == 5'b11001)
	pc_sel = 1;
    else
        pc_sel = branch_sel;
end

// mux A and mux B sel
reg A_sel_tmp;
assign A_sel_o = A_sel_tmp;
always @ (*)
begin
    if (instruction_i[6:2] == 5'b11001) A_sel_tmp = 0;
    else if (instruction_i[6:2] == 5'b00101)   A_sel_tmp = 1;  // auipc
    else A_sel_tmp = pc_sel;
end
reg B_sel;
assign B_sel_o = B_sel;
always @ (*)
begin
    if (reset_i)                                B_sel = 0;
    else if (instruction_6_to_2 == 5'b01100)    B_sel = 0;    // R format
    else                                        B_sel = 1;
end

// ALU select logic

wire [8:0] bits_of_instruction;
assign bits_of_instruction[8] = instruction_30;
assign bits_of_instruction[7:5] = instruction_14_to_12;
assign bits_of_instruction[4:0] = instruction_6_to_2;
reg [3:0] ALU_sel;
assign ALU_sel_o = ALU_sel;
always @ (*)
begin
    if (reset_i)
        ALU_sel = 0;
    else if (bits_of_instruction == 9'b1_000_01100)
        ALU_sel = `SUB;
    else if (bits_of_instruction == 9'b0_111_01100 || bits_of_instruction[7:0] == 8'b111_00100)
        ALU_sel = `AND;
    else if (bits_of_instruction == 9'b0_110_01100 || bits_of_instruction[7:0] == 8'b110_00100)
        ALU_sel = `OR;
    else if (bits_of_instruction == 9'b0_100_01100 || bits_of_instruction[7:0] == 8'b100_00100)
        ALU_sel = `XOR;
    else if (bits_of_instruction == 9'b0_001_01100 || bits_of_instruction[7:0] == 8'b001_00100)
        ALU_sel = `SLL;
    else if (bits_of_instruction == 9'b0_101_01100 || bits_of_instruction == 9'b0_101_00100)
        ALU_sel = `SRL;
    else if (bits_of_instruction == 9'b1_101_01100 || bits_of_instruction == 9'b1_101_00100)
        ALU_sel = `SRA;
    else if (bits_of_instruction == 9'b0_010_01100)
        ALU_sel = `SLT;
    else if (bits_of_instruction == 9'b0_011_01100)
        ALU_sel = `SLTU;
    else if (instruction_i[14:12] == 3'b010 && instruction_i[6:2] == 5'b00100)
        ALU_sel = `SLTI;
    else if (instruction_i[14:12] == 3'b011 && instruction_i[6:2] == 5'b00100)
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
    else if (instruction_6_to_2 == 5'b01000)   MemRW = 1;  // S format
    else                                    MemRW = 0;
end


// WB sel
reg [1:0] WBSel;
assign WBSel_o = WBSel;
always @ (*)
begin
    if (reset_i)                                WBSel = 0;
    else if (instruction_6_to_2 == 5'b11011)    WBSel = 2'b10;      // jal
    else if (instruction_6_to_2 == 5'b11001)	WBSel = 2'b10;
    else if (instruction_6_to_2 == 5'b00000)    WBSel = 2'b01;      // load instruction
    else if (instruction_6_to_2 == 5'b01101)    WBSel = 2'b11;      // lui
    else if (instruction_6_to_2 == 5'b00101)    WBSel = 2'b00;      // auipc
    else                                        WBSel = 2'b00;
end

endmodule

