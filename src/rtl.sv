module shifter (
  input clk,    // Clock
  input rst_n,
  input in,
  input oe,
  output q
);

logic [7:0] reg_shift = '0;
logic out;

always_ff @(posedge clk) begin : shifter_8
    if(~rst_n) begin
        reg_shift <= 0;
    end 
    else begin
        reg_shift <= {in, reg_shift[7:1]};

        out <= oe ? reg_shift[0] : 'x;
    end
end

assign q = out;

endmodule : shifter