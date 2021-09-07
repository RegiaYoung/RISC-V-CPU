

module sign_extention(
    input [31:0] instruction_i,
    input [2:0]  sext_sel_i,
    output [31:0] ext_from_sext_o
    );
parameter [2:0] I = 3'b001;
parameter [2:0] S = 3'b010;
parameter [2:0] B = 3'b011;
parameter [2:0] J = 3'b100;
parameter [2:0] U = 3'b101;

reg [31:0] extention;
assign ext_from_sext_o = extention;
always @ (*)
begin
    case(sext_sel_i)
        I:
            begin 
                extention[4:0]  = instruction_i[24:20];
                extention[10:5] = instruction_i[30:25];
                if(instruction_i[31])   extention[31:11] = 21'b1_1111_1111_1111_1111_1111;
                else                    extention[31:11] = 21'b0_0000_0000_0000_0000_0000;
            end
        S:
            begin
                extention[4:0] = instruction_i[11:7];
                extention[10:5] = instruction_i[30:25];
                if(instruction_i[31])   extention[31:11] = 21'b1_1111_1111_1111_1111_1111;
                else                    extention[31:11] = 21'b0_0000_0000_0000_0000_0000;
            end
        B:
            begin
                extention[0] = 0;
                extention[4:1] = instruction_i[11:8];
                extention[10:5] = instruction_i[30:25];
                extention[11] = instruction_i[7];
                if(instruction_i[31])   extention[31:12] = 20'b1111_1111_1111_1111_1111;
                else                    extention[31:12] = 20'b0000_0000_0000_0000_0000;
            end
    	J:
            begin
                extention[0] = 0;
                extention[10:1] = instruction_i[30:21];
                extention[11] = instruction_i[20];
                extention[19:12] = instruction_i[19:12];
                if(instruction_i[31])   extention[31:20] = 11'b1111_1111_111;
                else                    extention[31:20] = 11'b0000_0000_000;
            end
        U:
            begin
                extention[31:12] = instruction_i[31:12];
                extention[11:0] = 0;
            end
        default:extention = 0;
    endcase
end
endmodule
