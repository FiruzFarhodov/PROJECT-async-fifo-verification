`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "interface.sv"
class environment;

  generator gen;
  driver driv;
  monitor mon;
  scoreboard scb;
  
  mailbox gen2driv;
  mailbox mon2scb;
  
  event ended;
  
  virtual mem_interface mem_vif;
 
  function new (virtual mem_interface mem_vif);
    this.mem_vif = mem_vif;

    gen2driv = new();
    mon2scb  = new();
    
    gen = new(gen2driv, ended);
    driv = new(mem_vif, gen2driv);
    mon  = new(mem_vif, mon2scb);
    scb  = new(mon2scb);
  endfunction
  
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork
      gen.main();
      driv.drive();
      mon.main();
      scb.main();
    join_any

  endtask
  
  task post_test();
    //wait(ended.triggered);
    wait(gen.repeat_count == driv.num_transactions + driv.non_num_transactions);    
    repeat(3) @(mem_vif.read_driver_cb);
    wait(scb.fifo_q.size() == 0);
    $display("--------- [TEST PASSED / COMPLETED] ---------");

  endtask
  
  task run;
    pre_test();
    test();
    post_test();
    //repeat(2) @(mem_vif.read_driver_cb);
    //$finish;
  endtask
endclass 
