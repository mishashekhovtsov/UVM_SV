`timescale 1ns/1ps

`include "uvm_macros.svh"
`include "tb_pkg.svh"

module top;
  import uvm_pkg::*;

  bit rst_n;

  clk_gen_if clk_vif();
  shift_if shift_vif(.clk(clk_vif.clk_o));

  shifter dut (
    .clk    (clk_vif.clk_o),
    .rst_n  (rst_n        ),
    .in     (shift_vif.in ),
    .q      (shift_vif.out)
  );

  initial begin
    rst_n = 0;
    #10;
    rst_n = 1;
  end

  initial begin
    uvm_config_db#(virtual shift_if)::set(null, "*", "shift_vif", shift_vif);
    uvm_config_db#(virtual clk_gen_if)::set(null, "*", "clk_vif", clk_vif);
    run_test();
  end

endmodule : top