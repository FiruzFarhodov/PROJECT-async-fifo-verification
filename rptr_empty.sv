module rptr_empty #(parameter ADDRSIZE = 4)
  (
  input 			    rinc,
  input  [ADDRSIZE:0] rq2_wptr,
  input 			    rclk,
  input 			    rrst_n,
  
  output logic [ADDRSIZE:0]   rptr,
  output logic  			    rempty,
  output logic [ADDRSIZE-1:0] raddr
);
  
  logic [ADDRSIZE:0] rbin; // holds current read binary pointer
  logic [ADDRSIZE:0] rbin_next; // holds the next binary pointer
  logic [ADDRSIZE:0] rgray_next; // gray-coded pointer
  logic rempty_val;
  

  
  

  
  always_ff @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n) begin
      rbin <= 0;
      rptr <= 0;
    end else begin
      rbin <= rbin_next;
      rptr <= rgray_next;
    end
    
  end
  
  
  assign raddr = rbin[ADDRSIZE-1:0];
  assign rbin_next = rbin + (rinc & ~rempty);
  assign rgray_next = (rbin_next >> 1) ^ rbin_next;
  
  assign rempty_val = (rgray_next == rq2_wptr);
  
  always_ff @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n) begin
    rempty <= 1;
    end
    else
      rempty <= rempty_val;
  end

  
endmodule