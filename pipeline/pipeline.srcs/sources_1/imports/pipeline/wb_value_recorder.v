module wb_value_recorder(
    input rst_n,
    input clk_i,
    input [31:0] wb_value_i,
    output [31:0] wb_value_3_o,
    output [31:0] wb_value_2_o,
    output [31:0] wb_value_1_o,
    output [31:0] wb_value_0_o
    );

reg [31:0] wb_value_3;
reg [31:0] wb_value_2;
reg [31:0] wb_value_1;
assign wb_value_3_o = wb_value_3;
assign wb_value_2_o = wb_value_2;
assign wb_value_1_o = wb_value_1;
assign wb_value_0_o = wb_value_i;

always @ (posedge clk_i)
begin
    if (~rst_n)
    begin
        wb_value_3 <= 0;
        wb_value_2 <= 0;
        wb_value_1 <= 0;
    end
    else
    begin
        wb_value_3 <= wb_value_2;
        wb_value_2 <= wb_value_1;
        wb_value_1 <= wb_value_i;
    end
end
endmodule

