`include "environment.sv"
`include "assertions.sv"

`include "test_random.sv"
//`include "test_write_only.sv"
//`include "test_read_only.sv"
//`include "test_fifo_full.sv"
//`include "test_fifo_empty.sv"

module fifo_tb;
  bit wclk;
  bit rclk;
  bit wrst_n;
  bit rrst_n;
  
  mem_interface tif(wclk, rclk, wrst_n, rrst_n);
  
  FIFO1 DUT(
    .wdata(tif.wdata),
    .rdata(tif.rdata),
    .winc(tif.winc),
    .wclk(wclk),
    .wrst_n(wrst_n),
    .rinc(tif.rinc),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .wfull(tif.wfull),
    .rempty(tif.rempty)
  );

  fifo_assertions assertions_inst(
    .wclk(wclk),
    .wrst_n(wrst_n),
    .wfull(tif.wfull),
    .winc(tif.winc),
    .rclk(tif.rclk),
    .rrst_n(rrst_n),
    .rempty(tif.rempty),
    .rinc(tif.rinc)
  );
  
  
  // standard clocking 
  //always #5 wclk = ~wclk;
  //always #15 rclk = ~rclk;
  
  // clocking for fifo empty test case
  always #5 wclk = ~wclk;
  always #3 rclk = ~rclk;
  
  //Test Cases
  
  test_random test(tif);
  //test_write_only test(tif);
  //test_read_only test(tif);
  //test_fifo_full(tif);
  //test_fifo_empty(tif);
  
  environment env;
  initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0, fifo_tb);
end
  

  
  // useful for debugging 
initial begin
 $monitor("[%0t] wfull=%b | rempty=%b | w_en=%h | r_en=%h", 
           $time, tif.wfull, tif.rempty, tif.winc, tif.rinc);
end

  initial begin
    wclk = 0;
    rclk = 0;
    wrst_n = 0;
    rrst_n = 0;
    #20
    wrst_n = 1;
    rrst_n = 1;
  
  end
  
endmodule