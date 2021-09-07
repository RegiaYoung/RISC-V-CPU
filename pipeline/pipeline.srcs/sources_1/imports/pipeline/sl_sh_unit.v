module sl_sh_unit(
    input [31:0] instruction_i,
    input [1:0] addr_i,
    input [31:0] data_from_mem,
    input [31:0] data2_from_rf,
    output [31:0] wr_data_o
    );

reg [31:0] wr_data;
assign wr_data_o = wr_data;
always @ (*)
begin
    if (instruction_i[14:12] == 3'b000 && instruction_i[6:2] == 5'b01000)
    begin
        case(addr_i)
        2'b00:
        begin
            wr_data[31:8] = data_from_mem[31:8];
            wr_data[7:0]  = data2_from_rf[7:0];
        end
        2'b01:
        begin
            wr_data[31:16] = data_from_mem[31:16];
            wr_data[7:0] = data_from_mem[7:0];
            wr_data[15:8]  = data2_from_rf[7:0];
        end
        2'b10:
        begin
            wr_data[31:24] = data_from_mem[31:24];
            wr_data[15:0]  = data_from_mem[15:0];
            wr_data[23:16] = data2_from_rf[7:0];
        end
        2'b11:
        begin
            wr_data[23:0] = data_from_mem[23:0];
            wr_data[31:24]  = data2_from_rf[7:0];
        end
        default: wr_data = data_from_mem;
        endcase
    end
    else if (instruction_i[14:12] == 3'b001 && instruction_i[6:2] == 5'b01000)
    begin
        if (addr_i == 2'b00)
        begin
            wr_data[31:16] = data_from_mem[31:16];
            wr_data[15:0]  = data2_from_rf[15:0];
        end
        else
        begin
            wr_data[31:16] = data2_from_rf[15:0];
            wr_data[15:0]  = data_from_mem[15:0];
        end
    end
    else
        wr_data = data2_from_rf;
end

endmodule

