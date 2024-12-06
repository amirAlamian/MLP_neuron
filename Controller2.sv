module Controller2 #(
    parameter INPUT_NUM
) (
    input clk,
    input reset,
    input start,
    input new_weight,
    input input_available,
    output reg mux_select,
    output reg demux_select,
    output reg read_enable,
    output reg sram1_write_enable,
    output reg sram2_write_enable,
    output reg adder_register_write_enable,
    output reg [INPUT_NUM-1:0] sram1_write_address,
    output reg [INPUT_NUM-1:0] sram2_write_address,
    output reg [INPUT_NUM-1:0] sram1_read_address,
    output reg [INPUT_NUM-1:0] sram2_read_address
);

  reg write_turn;
  reg read_turn;

  always @(posedge new_weight, posedge reset) begin
    if (reset) begin
      demux_select <= 0;
      sram1_write_enable <= 0;
      sram2_write_enable <= 0;
      sram1_write_address <= -1;
      sram2_write_address <= -1;
      write_turn <= 0;
    end else begin
      if (write_turn == 0) begin
        sram2_write_enable <= 0;
        sram1_write_enable <= 1;
        demux_select <= 0;
        sram1_write_address += 1;
        if (sram1_write_address + 1'b1 == 0) begin
          write_turn <= 1;
        end
      end else begin
        sram2_write_enable <= 1;
        sram1_write_enable <= 0;
        demux_select <= 1;
        sram2_write_address += 1;
        if (sram2_write_address + 1'b1 == 0) begin
          write_turn <= 0;
        end
      end
    end
  end


  always @(posedge clk, posedge reset) begin
    if (reset || ~input_available) begin
      read_enable <= 0;
      mux_select <= 0;
      sram1_read_address <= -1;
      sram2_read_address <= -1;
      read_turn <= 0;
      adder_register_write_enable <= 0;
    end else begin
      read_enable <= 1;
      adder_register_write_enable <= 1;
      if (read_turn == 0) begin
        mux_select <= 0;
        sram1_read_address += 1;
        if (sram1_read_address + 1'b1 == 0) begin
          read_turn <= 1;
        end
      end else begin
        read_enable <= 1;
        mux_select  <= 1;
        sram2_read_address += 1;
        if (sram2_read_address + 1'b1 == 0) begin
          read_turn <= 0;
        end
      end

    end

  end

endmodule
