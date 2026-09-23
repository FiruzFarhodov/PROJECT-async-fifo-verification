module fifo_assertions(
  input logic wclk,
  input logic wrst_n,
  input logic wfull, 
  input logic winc,
  input logic rclk,
  input logic rrst_n,
  input logic rempty,
  input logic rinc
);
  property p_no_write_when_full;
    @(posedge wclk) disable iff(!wrst_n)
    tif.wfull |-> !tif.winc;
  endproperty
  
  assert_no_write_when_full: assert property (p_no_write_when_full) begin
	$display("FIFO Full detected; Write Enable successfully held low.");
    end else
  	$error("[%0t] Illegal write attempt while FIFO was full!", $time);
    
    
  property p_no_read_when_empty;
    @(posedge rclk) disable iff(!rrst_n)
    tif.rempty |-> !tif.rinc;
  endproperty
  
  assert_no_read_when_empty: assert property (p_no_read_when_empty)
   //$display("[%0t] FIFO READ EMPTY or OFF", $time);
    else
   $error("[%0t] Illegal write attempt while FIFO was EMPTY!", $time);    
    endmodule