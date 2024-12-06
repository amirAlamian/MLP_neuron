
module Multiplier #(
    parameter INPUT_WIDTH,
    parameter WEIGHT_WIDTH,
    parameter MULTIPLIED_WIDTH
) (
    input [INPUT_WIDTH -1:0] a,
    input [WEIGHT_WIDTH - 1:0] b,
    output signed [MULTIPLIED_WIDTH - 1:0] out
);

  assign out = $signed(a) * $signed(b);


endmodule
