`default_nettype wire
module TestBench ();
  reg clk;
  reg rst;
  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    #1 rst <= 1'bx;
    clk <= 1'bx;
    #(CLK_PERIOD) rst <= 1;
    #(CLK_PERIOD) rst <= 0;
    clk <= 0;
    $finish(2000);
  end


  PE pe (
      .mux_select(),
      .demux_select(),
      .read_enable(),
      .write_enable(),
      .clk(clk),
      .reset(rst),
      .input_data(),
      .weight(),
      .pe_out()
  );

endmodule

