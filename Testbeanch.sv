`default_nettype wire
module TestBench ();
  reg clk;
  reg rst;
  reg [31:0] input_data [0:66];  
  reg [31:0] weight [0:66];      
  wire [15:0] pe_out;    
  reg mux_select;
  reg demux_select;
  reg read_enable;
  reg write_enable;
  localparam CLK_PERIOD = 10;
  localparam INPUT_NUM = 32;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $readmemh("values4.txt", input_data);  
    $readmemh("values4.txt", weight); 
    #1 rst <= 1'b0;
    clk <= 1'b0;
    mux_select = 0;
    demux_select = 0;
    read_enable = 1;
    write_enable = 0;

    #(CLK_PERIOD) rst <= 1;
    #(CLK_PERIOD) rst <= 0;
    clk <= 0;
    $finish(2000);
  end


   PE pe (
      .mux_select(mux_select),
      .demux_select(demux_select),
      .read_enable(read_enable),
      .write_enable(write_enable),
      .clk(clk),
      .reset(rst),
      .input_data(input_data[0]),
      .weight(weight[0]),
      .pe_out(pe_out)
  );

endmodule
