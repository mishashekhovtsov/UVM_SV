`timescale 1ns/1ps

`include "uvm_macros.svh"
`include "tb_pkg.svh"

module top;
  import uvm_pkg::*;

  clk_gen_if clk_vif();
  rst_gen_if rst_vif  (.clk(clk_vif.clk_o));
  shift_if   shift_in_vif (.clk(clk_vif.clk_o), .rst_n(rst_vif.rst_o));
  shift_if   shift_out_vif(.clk(clk_vif.clk_o), .rst_n(rst_vif.rst_o));

  shifter dut (
    .clk   ( clk_vif.clk_o     ),
    .rst_n ( rst_vif.rst_o     ),
    .in    ( shift_in_vif.out  ),
    .oe    ( shift_out_vif.oe   ),
    .q     ( shift_out_vif.in  )
  );

  initial begin
    uvm_config_db#(virtual clk_gen_if)::set(null, "*", "clk_vif"      , clk_vif       );
    uvm_config_db#(virtual rst_gen_if)::set(null, "*", "rst_vif"      , rst_vif       );
    uvm_config_db#(virtual shift_if  )::set(null, "*", "shift_in_vif" , shift_in_vif  );
    uvm_config_db#(virtual shift_if  )::set(null, "*", "shift_out_vif", shift_out_vif );
    run_test();
  end

endmodule : top