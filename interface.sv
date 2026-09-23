 interface mem_interface #(parameter DSIZE = 8)(input logic wclk, rclk, wrst_n, rrst_n);
  logic [DSIZE-1:0] wdata;
  logic [DSIZE-1:0] rdata;
  
  logic winc; 
  logic rinc;

  logic wfull;
  logic rempty;
  
   
  
  clocking write_driver_cb @(posedge wclk);
    default input #1 output #0;
    output winc, wdata;
    input wfull;
  endclocking
  // master taking in 
  clocking read_driver_cb @(posedge rclk);
    default input #1 output #1;
    output rinc;
    input rempty, rdata;
  endclocking  
  
  clocking write_monitor_cb @(posedge wclk);
    default input #1 output #1;
	input winc, wdata, wrst_n, wfull;
  endclocking
  
  clocking read_monitor_cb @(posedge rclk);
    default input #1 output #1;
    input rinc, rrst_n, rdata, rempty;
  endclocking
  
  //driver modport
  modport driver_write (clocking write_driver_cb);
  modport driver_read  (clocking read_driver_cb);
  
 //monitor modports
  modport monitor_write (clocking write_monitor_cb);
  modport monitor_read (clocking read_monitor_cb);
    
    
endinterface
