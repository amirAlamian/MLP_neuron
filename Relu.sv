module Relu #(
    parameter NUM_BIT
) (
    input  [NUM_BIT - 1:0] x,
    output [NUM_BIT - 1:0] y
);

  assign y = x[NUM_BIT - 1] ? 1'b0 : x;
endmodule
