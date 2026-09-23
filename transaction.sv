class transaction #(parameter DSIZE = 8);
  // Random transaction fields (stimulus inputs driven by generator)
  rand logic [DSIZE-1:0] wdata;
  rand logic 		   	 winc;
  rand logic			 rinc;
  

  logic [DSIZE-1:0] rdata;
  logic 		    wfull;
  logic 		    rempty;
  bit 				is_reset; 
  
  /*
  constraint probability_winc {
    winc dist {
      1 := 80,
      0 := 20
    };
  }
  
  constraint probability_rinc {
    rinc dist {
      1 := 80,
      0 := 20
    };
  }
    */
endclass