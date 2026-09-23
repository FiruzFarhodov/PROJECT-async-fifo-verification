`include "fifomem.sv"
`include "sync_r2w.sv"
`include "sync_w2r.sv"
`include "rptr_empty.sv" 
`include "wptr_full.sv"
module FIFO1 #(parameter DSIZE = 8,
               parameter ASIZE = 4)
  (
   input  [DSIZE-1:0] wdata, // write data
   input 			  winc,		// write enable
   input 			  wclk,	// write clock
   input 			  wrst_n,  // write rst negedge
   input			  rinc,  // read enable 
   input 		      rclk,  // read clock
   input              rrst_n, // read reset negedge
   
   output [DSIZE-1:0] rdata,	// read data
   
   output 		      wfull,	// write full
   output 			  rempty	// write empty
);
  
  wire [ASIZE-1:0] waddr, raddr;
  wire [ASIZE:0] rptr, wq2_rptr, wptr, rq2_wptr;
  
  fifomem #(DSIZE, ASIZE) fifomem1 
 					    (.wdata(wdata) , .winc(winc) ,
                         .wfull(wfull) , .waddr(waddr) ,
                         .wclk(wclk) ,   .raddr(raddr) ,
                         .rdata(rdata));
  
  sync_r2w #(ASIZE) sync_r2w1 
  					(.wrst_n(wrst_n) , .wclk(wclk),
  					 .rptr(rptr) ,     .wq2_rptr(wq2_rptr));
  
  sync_w2r #(ASIZE) sync_w2r1
  					(.rrst_n(rrst_n), .rclk(rclk),
                     .wptr(wptr),     .rq2_wptr(rq2_wptr));
  
  rptr_empty #(ASIZE) rptr_empty1
  					(.rinc(rinc) ,  .rq2_wptr(rq2_wptr),
  					 .rclk(rclk) ,  .rrst_n(rrst_n),
  					 .rptr(rptr) , .rempty(rempty),
  					 .raddr(raddr));
  
  wptr_full #(ASIZE) wptr_full1
 				   (.winc(winc) ,     .wclk(wclk),
  				    .wrst_n(wrst_n) , .wq2_rptr(wq2_rptr),
   					.wfull(wfull) ,   .waddr(waddr),
   					.wptr(wptr));
 
endmodule
