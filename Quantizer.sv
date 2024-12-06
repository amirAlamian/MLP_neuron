module quantizer #(
    parameter num_bit = 16,       
    parameter out_bit = 8,       
    parameter fraction_out = 7, 
    parameter fraction_in = 14  
) (
    input  [num_bit - 1:0] in,
    output [out_bit - 1:0] out
);

    wire [num_bit - fraction_in - 1:0] int_in_part;
    wire [fraction_out - 1:0] fraction_out_part;

    assign int_in_part = in[num_bit - 1:fraction_in];
    assign fraction_out_part = in[fraction_in - 1:fraction_in - fraction_out];

    assign out = {int_in_part[out_bit - fraction_out - 1:0], fraction_out_part};

endmodule