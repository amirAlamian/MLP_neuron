module Mux #(
    parameter WEIGHT_WIDTH
) (
    input select,
    input [WEIGHT_WIDTH - 1:0] input1,
    input [WEIGHT_WIDTH - 1:0] input2,
    output [WEIGHT_WIDTH - 1:0] out
);

  assign out = select ? input2 : input1;

endmodule
