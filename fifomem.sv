module fifomem #(parameter DATASIZE = 8,
                  parameter ADDRSIZE = 4)
  
  (
  input      [DATASIZE-1:0] wdata,
  input				        winc,
  input   	  		        wfull,
  input      [ADDRSIZE-1:0] waddr,
  input	    			    wclk,
  input      [ADDRSIZE-1:0] raddr,
  output reg [DATASIZE-1:0] rdata
);
  
  localparam DEPTH = 1 << ADDRSIZE;
  reg [DATASIZE-1:0] mem [0:DEPTH-1];

  logic wclken;
  assign wclken = winc && !wfull;

  always_ff @(posedge wclk) begin
    if(wclken) begin
      mem[waddr] <= wdata;
    end
  end
  
  assign rdata = mem[raddr]; 
endmodule