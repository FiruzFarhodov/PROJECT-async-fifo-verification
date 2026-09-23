class generator;
  transaction trans;
  mailbox gen2driv;
  int repeat_count = 32'd50;
  event ended;
  
  
  function new(mailbox gen2driv, event ended);
    //getting the mailbox handle from env
    this.gen2driv = gen2driv;
    this.ended    = ended;
  endfunction
 
  virtual task main();
   repeat(repeat_count) begin
        trans = new();
      if(!trans.randomize()) // trans.randomzie with wenabel equal to 1
      $fatal("GEN:: trans randomization failed");
    gen2driv.put(trans);
    end
    -> ended;
    
  endtask
endclass
