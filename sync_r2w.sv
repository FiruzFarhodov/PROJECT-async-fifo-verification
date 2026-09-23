module sync_r2w #(parameter ADDRSIZE = 4)
  (
  input 			     wrst_n,
  input        		     wclk,
  input      [ADDRSIZE:0] rptr,
  output reg [ADDRSIZE:0] wq2_rptr
);
  
  logic [ADDRSIZE:0] wq1_rptr;
  
  
  always_ff @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
      wq1_rptr <= 0;
      wq2_rptr <= 0;
      
    end
    else if(wrst_n) begin
      wq1_rptr <= rptr;
      wq2_rptr <= wq1_rptr;
    end
  end
  
endmodule