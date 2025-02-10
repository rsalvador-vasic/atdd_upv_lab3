module counter #(
  parameter CNT_VAL_W = 8
)(
 input  logic clk,
 input  logic rst_n,
 input  logic en,
 input  logic clear,

 output logic [CNT_VAL_W-1:0] counter_val
);


always_ff @ (posedge clk or negedge rst_n)
  if(!rst_n)
    counter_val <= 'h0;
  else if (clear)
    counter_val <= 'h0;
  else if (en)
    counter_val <= counter_val + 1'b1;    // Increment. Let the counter overflow in this implementation

endmodule
