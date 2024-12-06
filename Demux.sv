
module Demux #(
    parameter WEIGHT_WIDTH
) (
    input select,
    input [WEIGHT_WIDTH - 1:0] in,
    output [WEIGHT_WIDTH - 1:0] out1,
    output [WEIGHT_WIDTH - 1:0] out2
);

    assign out1 = ~select & in;
    assign out2 = select & in;  

endmodule

