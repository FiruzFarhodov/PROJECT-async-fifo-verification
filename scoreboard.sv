class scoreboard #(parameter DSIZE = 8);
  
  mailbox mon2scb;
  
  int num_transactions;
  bit [DSIZE-1:0] fifo_q[$];
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
  task main();
    transaction trans;
    forever begin
      mon2scb.get(trans);
      if(trans.is_reset) begin
        fifo_q.delete();
      end 
            //--------------------------------
      		// WRITE observed
      		//--------------------------------
      if(trans.winc) begin
        
        //  $display("FIFO Full detected; Write Enable successfully held low.");
        
        fifo_q.push_back(trans.wdata);
        $display("[%0t] Recent: %d | Size: %d", $time, trans.wdata, fifo_q.size());
      end 
      
            //--------------------------------
      		// READ observed
      		//--------------------------------
      if(trans.rinc) begin
        bit [7:0] expected_data;
        
        if(fifo_q.size() > 0) begin
          expected_data = fifo_q.pop_front();

           if(trans.rdata == expected_data) begin
             $display("[%0t]Value: %d matches expected data: %d",$time, trans.rdata, expected_data);
        end 
          
          else begin
          $error("Value: %d DOES NOT matches expected data: %d", trans.rdata, expected_data);
        end
          
          num_transactions++;
        end  
      end
    end
      endtask
      
endclass