module wptr_full #(parameter ADDRSIZE = 4)
  (
  input winc, // write enable
  input wclk, // clock for write
  input wrst_n, // reset on low
  input [ADDRSIZE:0] wq2_rptr,  // gray code 
  
  output logic wfull,
  output [ADDRSIZE-1:0] waddr, // position in  decimal 
  output logic [ADDRSIZE:0] wptr // gray code
);
  
  logic              wfull_val;
  logic [ADDRSIZE:0] wbin; // current write binary
  logic [ADDRSIZE:0] wbin_next; // next write binary
  logic [ADDRSIZE:0] wgray_next; // next write gray
  
      
  assign wbin_next  = wbin + (winc & !wfull); 
  assign waddr      = wbin[ADDRSIZE-1:0];
  assign wgray_next = (wbin_next >> 1) ^ wbin_next;
  
  assign wfull_val  = (wgray_next == {~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});
  
  always_ff @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
      wptr <= 0;
      wbin <= 0;
      end else begin
        wbin <= wbin_next;
        wptr <= wgray_next;
      end
    end

  always_ff @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
      wfull <= 0;
    end else begin
     wfull <= wfull_val;
    end
  end
    
  
  
  
  
endmodule