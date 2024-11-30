module Relu #(
    parameter num_bit
) (
    input  [num_bit - 1:0] x,
    output [num_bit - 1:0] y
);

  assign y = x[num_bit-1] ? 1'b0 : x;
endmodule
