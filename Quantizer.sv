module Quantizer #(
    parameter INPUT_WIDTH,
    parameter OUTPUT_WIDTH,
    parameter FRACTION_OUT_BIT,
    parameter FRACTION_IN_BIT
) (
    input  [INPUT_WIDTH - 1:0] in,
    output [OUTPUT_WIDTH - 1:0] out
);

  wire [INPUT_WIDTH - FRACTION_IN_BIT - 1:0] int_in_part;
  wire [FRACTION_OUT_BIT - 1:0] fraction_out_part;

  assign int_in_part = in[INPUT_WIDTH - 1:FRACTION_IN_BIT];
  assign fraction_out_part = in[FRACTION_IN_BIT - 1:FRACTION_IN_BIT-FRACTION_OUT_BIT];

  assign out = {int_in_part[OUTPUT_WIDTH-FRACTION_OUT_BIT-1:0], fraction_out_part};

endmodule
