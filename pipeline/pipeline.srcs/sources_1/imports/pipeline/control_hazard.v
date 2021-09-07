module control_hazard(
    input rst_n,
    input clk_i,
    input [31:0] instruction_from_preg2_i,
    input [31:0] cmp_value2_i,
    input [31:0] cmp_value1_i,
    output bjump_o
    );
reg turn_over;
reg bjump = 0;
always @ (posedge clk_i)
begin
    turn_over = ~bjump;
end
assign bjump_o = bjump;
always @ (*)
begin
    if (~rst_n)
        bjump = 0;
    else if (turn_over == 0)
        bjump = 0;
    else if (instruction_from_preg2_i[6:2] == 5'b11000)
    begin
        case(instruction_from_preg2_i[14:12])
        3'b000:
        begin
            if (cmp_value2_i == cmp_value1_i)
                bjump = 1;
            else
                bjump = 0;
        end
        3'b001:
        begin
            if (cmp_value2_i == cmp_value1_i)
                bjump = 0;
            else
                bjump = 1;
        end
        3'b100:
        begin
            if ($signed(cmp_value1_i)  < $signed(cmp_value2_i))
                bjump = 1;
            else
                bjump = 0;
        end
        3'b101:
        begin
            if ($signed(cmp_value1_i) >= $signed(cmp_value2_i))
                bjump = 1;
            else
                bjump = 0;
        end
        3'b110:
        begin
            if (cmp_value1_i < cmp_value2_i)
                bjump = 1;
            else
                bjump = 0;
        end
        3'b111:
        begin
            if (cmp_value1_i >= cmp_value2_i)
                bjump = 1;
            else
                bjump = 0;
        end
        default: bjump = 0;
        endcase
    end
end

endmodule
