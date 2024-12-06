module PE #(
  parameter weight_bit = 32,
  parameter num_address = 512
)(
  input mux_select,
  input demux_select,
  input read_enable,
  input write_enable,
  input clk,
  input reset,
  input [weight_bit - 1:0] input_data,
  input [weight_bit - 1:0] weight,
  output [weight_bit - 1:0] pe_out
);

  wire [weight_bit - 1:0] demux_output1, demux_output2, mux_input1, mux_input2, mux_output, data_reg_output, accumulate_reg_data;
  wire [num_address - 1:0] sram1_address, sram2_address;
  wire [2*(weight_bit - 1):0] multiplier_result, adder_result, relu_result;
  Demux #weight_bit demux (
    .select(demux_select),
    .in(weight),
    .out1(demux_output1),
    .out2(demux_output2)
  );

  SRAM #(
    .num_bit(weight_bit),      
    .num_address(num_address) )
     sram1(
    .read_enable(read_enable),
    .write_enable(write_enable),
    .address(sram1_address),
    .read_data(mux_input1),
    .write_data(demux_output1)
  );

    SRAM #(
    .num_bit(weight_bit),      
    .num_address(num_address) )
    sram2(
    .read_enable(read_enable),
    .write_enable(write_enable),
    .address(sram2_address),
    .read_data(mux_input2),
    .write_data(demux_output2)
  );

  Mux #weight_bit mux (
    .select(mux_select),
    .input1(mux_input1),
    .input2(mux_input2),
    .out(mux_output)
  );

  Register #weight_bit input_reg (
    .clk(clk),
    .reg_write(1'b1),
    .reset(reset),
    .write_data(input_data),
    .read_data(data_reg_output)

  );


  Multiplier #weight_bit multiplier(
    .a(mux_output),
    .b(data_reg_output),
    .out(multiplier_result)
  );

  Adder #(2*weight_bit) adder(
    .a(multiplier_result),
    .b(accumulate_reg_data),
    .out(adder_result)
 );


  Register #(2*weight_bit) accumulate_reg (
    .clk(clk),
    .reg_write(1'b1),
    .reset(reset),
    .write_data(adder_result),
    .read_data(accumulate_reg_data)
  );


  Relu #(2*weight_bit) relu (
    .x(adder_result),
    .y(relu_result)
  );

  Quantizer #(2*weight_bit) quantizer (
    .in(relu_result),
    .out(pe_out)
  );
endmodule
