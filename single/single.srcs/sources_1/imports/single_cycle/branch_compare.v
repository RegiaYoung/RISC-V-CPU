module branch_compare(
    input [31:0] data1_from_rf_i,
    input [31:0] data2_from_rf_i,
    output [1:0] cmp_result_from_branch_o,
    input [2:0] func3
    );

reg [1:0] cmp_result_from_branch;
assign cmp_result_from_branch_o = cmp_result_from_branch;
always @ (*)
begin
    if (func3 == 3'b110 || func3 == 3'b111)  cmp_result_from_branch = ((~(data1_from_rf_i < data2_from_rf_i)) ? 2'b01 : 2'b10);
    else if (($signed(data1_from_rf_i)) == ($signed(data2_from_rf_i)))     cmp_result_from_branch = 2'b00;
    else if (($signed(data1_from_rf_i)) > ($signed(data2_from_rf_i))) cmp_result_from_branch = 2'b01;
    else                                        cmp_result_from_branch = 2'b10;
end
endmodule
