
module reg_file(
    input clk_i,
    input [4:0] rR1_i,
    input [4:0] rR2_i,
    input [4:0] wR_i,
    input WE_i,
    input [31:0] wD_i,
    output [31:0] rD1_o,
    output [31:0] rD2_o
    );

reg [31:0] register [0:31];
reg [31:0] data1;
reg [31:0] data2;
assign rD1_o = data1;
assign rD2_o = data2;

// read logic
always @ (*)
begin
    data1 = register[rR1_i];
    data2 = register[rR2_i];
end

// write logic
always @ (posedge clk_i)
begin
    register[0] <= 0;
    if (WE_i && wR_i != 0)
        register[wR_i] <= wD_i; 
end

endmodule
