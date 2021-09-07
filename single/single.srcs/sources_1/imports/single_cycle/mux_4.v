
module mux_4(
    input [0:1] select_signal,
    input [31:0] input0,
    input [31:0] input1,
    input [31:0] input2,
    input [31:0] input3,
    output [31:0] output_data
    );
reg [31:0] result;
assign output_data = result;
always @ (*)
begin
    case(select_signal)
        2'b00:  result = input0;
        2'b01:  result = input1;
        2'b10:  result = input2;
        2'b11:  result = input3;
        default:result = input0;
    endcase   
end
endmodule
