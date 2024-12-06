module Adder #(
    parameter NUM_BIT
) (
    input  [NUM_BIT - 1:0] a,
    input  [NUM_BIT - 1:0] b,
    output [NUM_BIT - 1:0] out

);
  assign out = a + b;

endmodule
