
module Multiplier #(
    parameter num_bit
) (
    input [num_bit -1:0] a,
    input [num_bit - 1:0] b,
    output [2*(num_bit - 1):0] out
);

  assign out = a * b;

endmodule
