module mux_7(
    input [2:0] select_signal,
    input [31:0] input0,
    input [31:0] input1,
    input [31:0] input2,
    input [31:0] input3,
    input [31:0] input4,
    input [31:0] input5,
    input [31:0] input6,
    output [31:0] output_data
    );
reg [31:0] result;
assign output_data = result;
always @ (*)
begin
    case(select_signal)
        3'b000:  result = input0;
        3'b001:  result = input1;
        3'b010:  result = input2;
        3'b011:  result = input3;
        3'b100:  result = input4;
        3'b101:  result = input5;
        3'b110:  result = input6;
        default:result = input0;
    endcase   
end
endmodule
