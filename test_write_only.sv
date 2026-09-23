
// only extend generator 

class sub_generator extends generator;
  transaction trans;
  int repeat_count = 32'd50;

  function new(mailbox gen2driv, event ended);
    super.new(gen2driv, ended);
  endfunction
 
  virtual task main();
    $display("[GEN] Write only Generator Activated");
    
    repeat(repeat_count) begin
      trans = new();
      if (!trans.randomize() with { winc == 1'b1; rinc == 1'b0; }) begin
      $fatal(1, "[GEN] Transaction randomization failed!");
    end
    gen2driv.put(trans);
    end
    -> ended;
  endtask
  
  
  
  
  
endclass


module test_write_only(mem_interface tif);
  environment env;
  sub_generator gen1;
  
  initial begin  
    env = new(tif); 
    gen1 = new(env.gen2driv, env.ended);   
    env.gen = gen1; 
    
    fork 
    env.run();
	
    join_none
    @(posedge tif.wfull);
    $display("[TEST] Async FIFO Write Only Test Completed Successfully.");
    $finish;
    
  end
endmodule