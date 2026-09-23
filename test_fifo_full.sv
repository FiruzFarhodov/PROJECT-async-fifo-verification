
module test_fifo_full(mem_interface tif);
  
  environment env;
  
  
  
  initial begin
    
    fork 
    env = new(tif);
    env.run();
    
    join_none
    @(posedge tif.wfull)
    $display("[TEST] Async FIFO test Fifo Full Completed Successfully.");
    $finish;
  end
endmodule