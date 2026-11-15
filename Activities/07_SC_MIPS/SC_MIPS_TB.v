`timescale 1ns/1ns
module SC_MIPS_TB();

reg clk, reset;

SC_MIPS dut(.clk(clk), .reset(reset));

initial clk = 0;
always #5 clk = ~clk;

initial begin
    reset = 1;
    #10;
    reset = 0;
    #50;     // 5 instrucciones × 10 ns
    $stop;
end
endmodule