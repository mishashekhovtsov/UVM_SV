module shifter (
  input clk,    // Clock
  input rst_n,
  input in,
  output q
);

logic [7:0] reg_shift = '0;

always_ff @(posedge clk) begin : shifter_8
  if(~rst_n) begin
    reg_shift <= 0;
  end 
  else begin
    reg_shift <= {in, reg_shift[7:1]};
  end
end

assign q = reg_shift[0];

endmodule : shifter