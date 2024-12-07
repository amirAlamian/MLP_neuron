`default_nettype wire `timescale 1ns / 1ns
parameter INPUT_WIDTH = 8;
parameter INPUT_FRACTION = 6;
parameter WEIGHT_WIDTH = 8;
parameter WEIGHT_FRACTION = 6;
parameter INPUT_NUM = 32;
parameter FRACTION_OUT_BIT = 6;
parameter PE_OUT_WIDTH = 8;
module TestBench ();
  reg clk;
  reg rst;
  reg [INPUT_WIDTH - 1:0] data[0:INPUT_NUM - 1];
  reg [WEIGHT_WIDTH - 1:0] weight[0:INPUT_NUM - 1];
  wire [PE_OUT_WIDTH - 1:0] pe_out;
  reg [WEIGHT_WIDTH - 1:0] input_weight;
  reg [INPUT_WIDTH - 1:0] input_data;
  reg new_weight;
  reg input_available;
  localparam CLK_PERIOD = 10;

  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $readmemh("./inputs.txt", data);
    $readmemh("./weights.txt", weight);
    #0 rst <= 1'b1;
    clk <= 1'b0;
    input_available = 0;
    #(CLK_PERIOD / 2) rst <= 0;
    #(4 * CLK_PERIOD / 3) input_available <= 1;
    #2000 $stop;
  end


  int initial_address = 0;

  always @(posedge clk, rst) begin
    if (rst) begin
      initial_address = 0;
    end else begin
      input_weight <= weight[initial_address];
      if (initial_address < INPUT_NUM - 1) begin
        initial_address += 1;
      end
      if (initial_address <= INPUT_NUM) begin
        new_weight <= 1;
      end
    end
  end


  int input_address = 0;
  always @(negedge clk, rst) begin
    if (rst) begin
      input_address = 0;
    end else begin
      if (input_available) begin
        input_data <= data[input_address];
        input_address += 1;
        if (input_address > INPUT_NUM) begin
          input_available <= 0;
        end
      end
    end
  end

  always @(negedge clk) begin
    new_weight = 0;
  end

  PE #(
      .INPUT_WIDTH(INPUT_WIDTH),
      .WEIGHT_WIDTH(WEIGHT_WIDTH),
      .INPUT_NUM(INPUT_NUM),
      .PE_OUT_WIDTH(PE_OUT_WIDTH),
      .FRACTION_IN_BIT(INPUT_FRACTION + WEIGHT_FRACTION),
      .FRACTION_OUT_BIT(FRACTION_OUT_BIT)
  ) pe (
      .new_weight(new_weight),
      .input_available(input_available),
      .clk(clk),
      .reset(rst),
      .input_data(input_data),
      .weight(input_weight),
      .pe_out(pe_out)
  );

endmodule
