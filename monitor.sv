`define WRITE_IF_MON mem_vif.write_monitor_cb
`define READ_IF_MON mem_vif.read_monitor_cb
class monitor; 
  
  virtual mem_interface mem_vif;
  
  mailbox mon2scb;
  
  function new(virtual mem_interface mem_vif, mailbox mon2scb);
    this.mem_vif = mem_vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task write_monitor;
    forever begin
      transaction trans;

      @(mem_vif.write_monitor_cb);
      if(!`WRITE_IF_MON.wrst_n) begin
        trans = new();
        trans.is_reset = 1;
        mon2scb.put(trans);
        $display("[%0t] [MONITOR] Write Reset detected", $time);
      end 
      
	  else if (`WRITE_IF_MON.winc && !`WRITE_IF_MON.wfull) begin
        trans = new();
        trans.is_reset = 0;
        $display("[%0t]--------- [WRITE-INPUT] ---------", $time);
        trans.winc  = 1'b1;
        trans.wdata = `WRITE_IF_MON.wdata;
        mon2scb.put(trans);
      end
    end
 endtask
      
  task read_monitor;
    forever begin
      transaction trans;
      @(mem_vif.read_monitor_cb);
      if (`READ_IF_MON.rinc && !`READ_IF_MON.rempty) begin       
        trans = new();

        trans.rinc  = 1'b1;
        trans.rdata = `READ_IF_MON.rdata;
        $display("[%0t]--------- [READ-OUTPUT] ---------", $time);
        mon2scb.put(trans);
      end
    end
  endtask
      
      task main();
        fork
          write_monitor();
          read_monitor();
        join_none
      endtask
      
endclass