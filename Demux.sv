
module Demux #(
    parameter num_bit
) (
    input select,
    input [10:0] in,
    output [num_bit - 1:0] out1,
    output [num_bit - 1:0] out2
);

  assign {out1, out2} = select ? {1'b0, in} : {in, 1'b0};

endmodule

