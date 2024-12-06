module SRAM #(
    parameter WEIGHT_WIDTH,
    parameter INPUT_NUM
) (
    input clk,
    input read_enable,
    input write_enable,
    input [INPUT_NUM - 1:0] read_address,
    input [INPUT_NUM - 1:0] write_address,
    input [WEIGHT_WIDTH - 1:0] write_data,
    output reg [WEIGHT_WIDTH - 1:0] read_data
);
  reg [WEIGHT_WIDTH - 1:0] mem_data[0:INPUT_NUM -1];


  always @(posedge clk) begin
    if (write_enable) begin
      mem_data[write_address] <= write_data;
    end
  end

  always @(read_address, read_enable) begin
    if (read_enable) read_data <= mem_data[read_address];
    else read_data <= 32'b0;
  end



endmodule
