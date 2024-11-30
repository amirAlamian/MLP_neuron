
module Register #(
    parameter num_bit
) (
    input clk,
    input reg_write,
    input reset,
    input [num_bit - 1:0] write_data,
    output reg [num_bit - 1:0] read_data
);
  always @(posedge clk, reset) begin
    if (reset) begin
      read_data = 0;
    end else if (reg_write) begin
      read_data <= write_data;
    end
  end


endmodule
