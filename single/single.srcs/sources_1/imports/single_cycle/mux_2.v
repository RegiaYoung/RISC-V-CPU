

module mux_2(
    input select_signal,
    input [31:0] input0,
    input [31:0] input1,
    output [31:0] output_data
    );

reg [31:0] result;
assign output_data = result;
always @ (*)
begin
    if(select_signal)   result = input1;
    else                result = input0;
end
endmodule
