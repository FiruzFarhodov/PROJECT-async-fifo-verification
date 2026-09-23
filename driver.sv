`define WRITE_IF mem_vif.write_driver_cb
`define READ_IF mem_vif.read_driver_cb
class driver;
  
  //used to count number of transactions
  int num_transactions = 0;
  int non_num_transactions	   = 0;
  //creating virtual interface handle
  virtual mem_interface mem_vif;
  
  //creating mailbox handle
  mailbox gen2driv;
  
  //constructor
  function new(virtual mem_interface mem_vif, mailbox gen2driv);
    //getting the interface
    this.mem_vif = mem_vif;
    //getting the mailbox handle from environment 
    this.gen2driv = gen2driv;
  endfunction
  
  task reset_write;
    wait(!mem_vif.wrst_n);
    $display("--------- [DRIVER] Write Reset Started ---------");
    `WRITE_IF.winc    <= 0;
    `WRITE_IF.wdata   <= 0;
     num_transactions <= 0;
     non_num_transactions	      <= 0;
    wait(mem_vif.wrst_n);
    $display("--------- [DRIVER] Write Reset Finished ---------");
  endtask
    
  task reset_read;
    wait(!mem_vif.rrst_n);
    $display("--------- [DRIVER] Read Reset Started ---------");
    `READ_IF.rinc <= 0;
    wait(mem_vif.rrst_n);
    $display("--------- [DRIVER] Read Reset Finished ---------");
  endtask
  
  task reset;
    fork
      reset_write();
      reset_read();
    join
  endtask
  
  task drive_write;
    forever begin
      transaction trans;
      gen2driv.get(trans);
     // $display("DRIVER::    wdata:%d , winc:%d, rinc:%d",trans.wdata, trans.winc, trans.rinc);
      $display("[%0t]--------- [TRANSFERING INST:%0d] ---------", $time, num_transactions);
      @(mem_vif.write_driver_cb); 
      if(`WRITE_IF.wfull == 0 && trans.winc) begin
        $display("[%0t]--------- [WRITING] ---------", $time);
			`WRITE_IF.wdata <= trans.wdata;
      		`WRITE_IF.winc  <= 1'b1;
        @(mem_vif.write_driver_cb);
      		`WRITE_IF.winc  <= 1'b0;
        	num_transactions++;
      end else begin 
        `WRITE_IF.winc <= 1'b0;
        non_num_transactions++;
        //num_transactions++; // this would be needed
        @(mem_vif.write_driver_cb);
      end
    end
  endtask
  
  task drive_read;
    forever begin       
      transaction trans;
      gen2driv.get(trans);      
      @( mem_vif.read_driver_cb);
      if(`READ_IF.rempty == 0 && trans.rinc) begin
        $display("[%0t]--------- [READING] ---------", $time);
        `READ_IF.rinc <= 1'b1;
        @(mem_vif.read_driver_cb);
        `READ_IF.rinc <= 1'b0;
      end else begin
        `READ_IF.rinc <= 1'b0;
      end
    end
  endtask
  
  
  virtual task drive();
    fork
      drive_write();
      drive_read();
    join_none
  endtask 
  
endclass
