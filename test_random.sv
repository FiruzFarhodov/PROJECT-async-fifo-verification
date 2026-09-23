program test_random(mem_interface tif);
  
  environment env;
  
  initial begin
    
    fork 
    env = new(tif);
    env.run();
    
    join_none
    #800;
    $display("[TEST] Async FIFO Test Completed Successfully.");
    $finish;
  end
endprogram