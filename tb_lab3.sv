`timescale 1ns/100ps

module tb_lab3 ();

// Define Parameters and Logics

localparam sim_time = 180000; // Simulation time in ns

localparam s_clk_per = 150.0;   // source s_clk period in ns

localparam d_clk_per = 490.0;   // destination d_clk period in ns


logic poweron_rst_n;    // Power-On Reset, from voltage monitor
logic s_clk;
logic d_clk;

logic  [3:0] s_addr;
logic [15:0] s_wr_data;
logic        s_wr_en;
logic        s_rd_en;
logic [15:0] s_rd_data;
logic        s_rd_data_valid;

typedef struct packed { 
  logic        wr_en;
  logic        rd_en;
  logic  [3:0] addr;
  logic [15:0] wr_data;

} data_pkt;

parameter data_pkt array_data_transfers [0:31] =
//wr_en, rd_en, addr ,data        
'{{1'b1 ,1'b0, 4'h1, 16'h0001}, // Write sequence
 '{1'b1 ,1'b0, 4'h2, 16'h0002},
 '{1'b1 ,1'b0, 4'h3, 16'h0003},
 '{1'b1 ,1'b0, 4'h4, 16'h0004},
 '{1'b1 ,1'b0, 4'h5, 16'h0005},
 '{1'b1 ,1'b0, 4'h6, 16'h0006},
 '{1'b1 ,1'b0, 4'h7, 16'h0007},
 '{1'b1 ,1'b0, 4'h8, 16'h0008},
 '{1'b1 ,1'b0, 4'h9, 16'h0009},
 '{1'b1 ,1'b0, 4'hA, 16'h000A},
 '{1'b1 ,1'b0, 4'hB, 16'h000B},
 '{1'b1 ,1'b0, 4'hC, 16'h000C},
 '{1'b1 ,1'b0, 4'hD, 16'h000D},
 '{1'b1 ,1'b0, 4'hE, 16'h000E},
 '{1'b1 ,1'b0, 4'hF, 16'h000F},
 '{1'b0 ,1'b1, 4'h0, 16'h0000}, // Read sequence
 '{1'b0 ,1'b1, 4'h1, 16'h0000},
 '{1'b0 ,1'b1, 4'h2, 16'h0000},
 '{1'b0 ,1'b1, 4'h3, 16'h0000},
 '{1'b0 ,1'b1, 4'h4, 16'h0000},
 '{1'b0 ,1'b1, 4'h5, 16'h0000},
 '{1'b0 ,1'b1, 4'h6, 16'h0000},
 '{1'b0 ,1'b1, 4'h7, 16'h0000},
 '{1'b0 ,1'b1, 4'h8, 16'h0000},
 '{1'b0 ,1'b1, 4'h9, 16'h0000},
 '{1'b0 ,1'b1, 4'hA, 16'h0000},
 '{1'b0 ,1'b1, 4'hB, 16'h0000},
 '{1'b0 ,1'b1, 4'hC, 16'h0000},
 '{1'b0 ,1'b1, 4'hD, 16'h0000},
 '{1'b0 ,1'b1, 4'hE, 16'h0000},
 '{1'b0 ,1'b1, 4'hF, 16'h0000},
 '{1'b1 ,1'b0, 4'h2, 16'h0001} // Write to set soft reset
};

logic [4:0] cnt;



// Generate free-running clock sources

initial begin
    s_clk = 1'b0;
    forever 
      s_clk = #(s_clk_per/2) !s_clk;
end

initial begin
    d_clk = 1'b0;
    forever 
      d_clk = #(d_clk_per/2) !d_clk;
end



// Release Power-On reset before clock sources toggle

initial begin
  poweron_rst_n = 1'b0;
  #138ns;
  poweron_rst_n = 1'b1;
end



initial begin
  s_addr    = 'h0;
  s_wr_data = 'h0;
  s_wr_en   = 'h0;
  s_rd_en   = 'h0;
  cnt       = 'h0;

  forever begin
    repeat (15) @ (posedge s_clk);
    #1;
    {s_wr_en,s_rd_en,s_addr,s_wr_data} = array_data_transfers[cnt];  // Apply new access command
    cnt++; 
    repeat (1) @ (posedge s_clk);
    #1;
    {s_wr_en,s_rd_en,s_addr,s_wr_data} = 'h0;                        // Clear bus 

  end
end




// Dump waveforms and stop simulation

initial begin
    $shm_open(,1);
    $shm_probe("ACTM");
    #(sim_time);
    $finish();
end


// Instantiate DUT

dut_lab3 u_dut_lab3(
  // Inputs
  .s_clk              (s_clk),
  .d_clk              (d_clk),
  .poweron_rst_n      (poweron_rst_n),

  .s_addr             (s_addr),
  .s_wr_data          (s_wr_data),
  .s_wr_en            (s_wr_en),
  .s_rd_en            (s_rd_en),

  // Outputs
  .s_rd_data          (s_rd_data),
  .s_rd_data_valid    (s_rd_data_valid)
);



endmodule
