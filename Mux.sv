module Mux #(
    parameter num_bit
) (
    input select,
    input [num_bit - 1:0] input1,
    input [num_bit - 1:0] input2,
    output [num_bit - 1:0] out
);

  assign out = select ? input2 : input1;

endmodule
