module SRAM #(
    parameter num_bit,
    parameter num_address
) (
    input read_enable,
    input write_enable,
    input [num_address - 1:0] address,
    input [num_bit - 1:0] write_data,
    output reg [num_bit - 1:0] read_data
);
  reg [num_bit - 1:0] mem_data[0:num_address -1];


  always @(write_enable) begin
    mem_data[address] <= write_data;
  end

  always @(read_enable) begin
    read_data <= mem_data[address];
  end


endmodule
