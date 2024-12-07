module PE #(
  parameter INPUT_WIDTH,
  parameter WEIGHT_WIDTH,
  parameter INPUT_NUM,
  parameter PE_OUT_WIDTH,
  parameter FRACTION_IN_BIT,
  parameter FRACTION_OUT_BIT
)(
  input new_weight,
  input input_available,
  input clk,
  input reset,
  input [INPUT_WIDTH - 1:0] input_data,
  input [WEIGHT_WIDTH - 1:0] weight,
  output [PE_OUT_WIDTH - 1:0] pe_out
);
  localparam MULTIPLIED_WIDTH = INPUT_WIDTH + WEIGHT_WIDTH;
  wire [WEIGHT_WIDTH - 1:0] demux_output1, demux_output2, mux_input1, mux_input2, mux_output;
  wire [INPUT_WIDTH - 1:0] data_reg_output;
  reg [INPUT_NUM - 1:0] sram1_write_address, sram1_read_address;
  reg [INPUT_NUM - 1:0] sram2_write_address,sram2_read_address;
  wire [MULTIPLIED_WIDTH - 1:0] multiplier_result, adder_result, relu_result, accumulate_reg_data;
  reg sram1_write_enable, sram2_write_enable, read_enable, adder_register_write_enable, mux_select, demux_select;

  Demux #WEIGHT_WIDTH demux (
    .select(demux_select),
    .in(weight),
    .out1(demux_output1),
    .out2(demux_output2)
  );

  SRAM #(
    .WEIGHT_WIDTH(WEIGHT_WIDTH),      
    .INPUT_NUM(INPUT_NUM) 
    )
    sram1(
    .clk(clk),
    .read_enable(read_enable),
    .write_enable(sram1_write_enable),
    .write_address(sram1_write_address),
    .read_address(sram1_read_address),
    .read_data(mux_input1),
    .write_data(demux_output1)
  );

    SRAM #(
    .WEIGHT_WIDTH(WEIGHT_WIDTH),      
    .INPUT_NUM(INPUT_NUM)
    )
    sram2(
    .clk(clk),
    .read_enable(read_enable),
    .write_enable(sram2_write_enable),
    .write_address(sram2_write_address),
    .read_address(sram2_read_address),
    .read_data(mux_input2),
    .write_data(demux_output2)
  );

  Mux #WEIGHT_WIDTH mux (
    .select(mux_select),
    .input1(mux_input1),
    .input2(mux_input2),
    .out(mux_output)
  );

  Register #INPUT_WIDTH input_reg (
    .clk(clk),
    .reg_write(1'b1),
    .reset(reset),
    .write_data(input_data),
    .read_data(data_reg_output)

  );


  Multiplier #(
    .WEIGHT_WIDTH(WEIGHT_WIDTH),
    .INPUT_WIDTH(INPUT_WIDTH),
    .MULTIPLIED_WIDTH(MULTIPLIED_WIDTH)
    ) multiplier(
    .a(mux_output),
    .b(data_reg_output),
    .out(multiplier_result)
  );

  Adder #MULTIPLIED_WIDTH adder(
    .a(multiplier_result),
    .b(accumulate_reg_data),
    .out(adder_result)
  );



  Register #MULTIPLIED_WIDTH accumulate_reg (
    .clk(clk),
    .reg_write(adder_register_write_enable),
    .reset(reset),
    .write_data(adder_result),
    .read_data(accumulate_reg_data)
  );


  Relu #MULTIPLIED_WIDTH relu (
    .x(adder_result),
    .y(relu_result)
  );

  Quantizer #(
    .INPUT_WIDTH(MULTIPLIED_WIDTH),
    .OUTPUT_WIDTH(PE_OUT_WIDTH),
    .FRACTION_OUT_BIT(FRACTION_OUT_BIT),
    .FRACTION_IN_BIT(FRACTION_IN_BIT)
  ) quantizer (
    .in(relu_result),
    .out(pe_out)
  );

    Controller #INPUT_NUM controller(
    .clk(clk),
    .reset(reset),
    .start(start),
    .new_weight(new_weight),
    .input_available(input_available),
    .mux_select(mux_select),
    .demux_select(demux_select),
    .read_enable(read_enable),
    .adder_register_write_enable(adder_register_write_enable),
    .sram1_write_enable(sram1_write_enable),
    .sram2_write_enable(sram2_write_enable),
    .sram1_write_address(sram1_write_address),
    .sram2_write_address(sram2_write_address),
    .sram1_read_address(sram1_read_address),
    .sram2_read_address(sram2_read_address)
  );
endmodule
