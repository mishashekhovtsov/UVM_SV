`timescale 1ns/1ps

`include "uvm_macros.svh"
`include "../../common/shift/shift_if_pkg/shift_pkg.sv"
`include "shift_if.sv"

module top;
  import uvm_pkg::*;
  import tb_pkg::*;

  bit rst_n;

  shift_if vif();

  initial begin
    vif.clk = 0;
    forever #5 vif.clk = ~vif.clk;
  end

  shifter dut (
    .clk    (vif.clk),
    .rst_n  (rst_n  ),
    .in     (vif.in ),
    .q      (vif.out)
    );

  initial begin
    rst_n = 0;
    #10;
    rst_n = 1;
  end

  initial begin
    uvm_config_db#(virtual shift_if)::set(null, "*", "vif", vif);
    $dumpfile("dump.vcd"); 
    $dumpvars;
    run_test();
  end

endmodule : top