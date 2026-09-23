  covergroup fifo_wclk_cg @(posedge wclk);
    // 1. Cover FIFO Full State
    cp_full : coverpoint tif.wfull {
      bins full     = {1};
      bins not_full = {0};
    }
    
    cp_winc : coverpoint tif.winc {
        bins write_active   = {1};
        bins write_inactive = {0};
    }
    cross_full_write: cross cp_full, cp_winc;
  endgroup
  
      covergroup fifo_rclk_cg @(posedge rclk);
        // Cover FIFO Empty State
        
        cp_empty : coverpoint tif.rempty {
          bins empty  	 = {1};
          bins not_empty = {0};
        }
        
        cp_rinc : coverpoint tif.rinc {
          bins read_active   = {1};
          bins read_inactive = {0};
        }  
        cross_empty_read: cross cp_empty, cp_rinc;
      endgroup
  
  fifo_wclk_cg cg_wclk = new();
  fifo_rclk_cg cg_rclk = new();