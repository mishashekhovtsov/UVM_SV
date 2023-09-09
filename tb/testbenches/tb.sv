`timescale 1ns/1ps

`include "uvm_macros.svh"
`include "../../common/clk_gen/clk_gen_pkg/clk_gen_pkg.sv"
`include "clk_gen_if.sv"
`include "../../common/shift/shift_if_pkg/shift_pkg.sv"
`include "shift_if.sv"

module top;
  import uvm_pkg::*;
  import tb_pkg::*;

  bit rst_n;

  clk_gen_if clk_vif();
  shift_if shift_vif(.clk(clk_vif.clk_o));

  // initial begin
  //   shift_vif.clk = 0;
  //   forever #5 shift_vif.clk = ~shift_vif.clk;
  // end

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