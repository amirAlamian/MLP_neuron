
module Register #(
    parameter NUM_BIT
) (
    input clk,
    input reg_write,
    input reset,
    input [NUM_BIT - 1:0] write_data,
    output reg [NUM_BIT - 1:0] read_data
);
  always @(posedge clk, reset) begin
    if (reset) begin
      read_data = 0;
    end else if (reg_write) begin
      read_data <= write_data;
    end else begin
      read_data <= read_data;
    end
  end


endmodule
