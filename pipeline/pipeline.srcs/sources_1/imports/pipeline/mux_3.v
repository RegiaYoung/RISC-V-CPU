module mux_3(
    input [1:0] select_signal,
    input [31:0] input0,
    input [31:0] input1,
    input [31:0] input2,
    output [31:0] output_data
    );

reg [31:0] output_reg;
assign output_data = output_reg;
always @ (*)
begin
    case(select_signal)
    2'b00: output_reg = input0;
    2'b01: output_reg = input1;
    2'b10: output_reg = input2;
    default: output_reg = input0;
    endcase
end
endmodule
