module lb_lh_unit(
    input [31:0] instruction_i,
    input [1:0] addr_i,
    input [31:0] write_back_data_from_mux4,
    output [31:0] wb_data_o
    );

reg [31:0] wb_data;
assign wb_data_o = wb_data;
always @ (*)
begin
    if ((instruction_i[14:12] == 3'b000 || instruction_i[14:12] == 3'b100) && instruction_i[6:2] == 5'b00000)
    begin
        case(addr_i)
        2'b00:  begin 
                wb_data[7:0] = write_back_data_from_mux4[7:0];
                if (instruction_i[14:12] == 3'b000 && write_back_data_from_mux4[7] == 1)
                    wb_data[31:8] = 24'b1111_1111_1111_1111_1111_1111;
                else
                    wb_data[31:8] = 0;
                end
        2'b01:  begin 
                wb_data[7:0] = write_back_data_from_mux4[15:8];
                if (instruction_i[14:12] == 3'b000 && write_back_data_from_mux4[15] == 1)
                    wb_data[31:8] = 24'b1111_1111_1111_1111_1111_1111;
                else
                    wb_data[31:8] = 0;
                end
        2'b10:  begin 
                wb_data[7:0] = write_back_data_from_mux4[23:16];
                if (instruction_i[14:12] == 3'b000 && write_back_data_from_mux4[23] == 1)
                    wb_data[31:8] = 24'b1111_1111_1111_1111_1111_1111;
                else
                    wb_data[31:8] = 0;
                end
        2'b11:  begin 
                wb_data[7:0] = write_back_data_from_mux4[31:24];
                if (instruction_i[14:12] == 3'b000 && write_back_data_from_mux4[31] == 1)
                    wb_data[31:8] = 24'b1111_1111_1111_1111_1111_1111;
                else
                    wb_data[31:8] = 0;
                end
         endcase 
    end
    else if ((instruction_i[14:12] == 3'b001 || instruction_i[14:12] == 3'b101) && instruction_i[6:2] == 5'b00000)
    begin
        case(addr_i)
        2'b00: begin
                wb_data[15:0] = write_back_data_from_mux4[15:0];
                if (instruction_i[14:12] == 3'b001 && write_back_data_from_mux4[15] == 1)
                    wb_data[31:16] = 16'b1111_1111_1111_1111;
                else
                    wb_data[31:16] = 0;
                end
        default:begin
                wb_data[15:0] = write_back_data_from_mux4[31:16];
                if (instruction_i[14:12] == 3'b001 && write_back_data_from_mux4[31] == 1)
                    wb_data[31:16] = 16'b1111_1111_1111_1111;
                else
                    wb_data[31:16] = 0;
                end
        endcase
    end
    else
        wb_data = write_back_data_from_mux4;
end
endmodule

