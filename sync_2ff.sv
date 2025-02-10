module sync_2ff(
  input  logic clk,
  input  logic rst_n,
  input  logic in,
  output logic out
);

logic sync_1;
logic sync_2;

always_ff @ (posedge clk or negedge rst_n)
  if(!rst_n) begin
    sync_1 <= 1'b0;
    sync_2 <= 1'b0;
  end
  else begin
    sync_1 <= in;
    sync_2 <= sync_1;
  end

always_comb out = sync_2;

endmodule
