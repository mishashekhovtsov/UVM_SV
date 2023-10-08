`timescale 1ns/1ps
`include "clk_gen_if.sv"

package clk_gen_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "clk_gen_trans.svh"
    `include "clk_gen_seqr.svh"
    `include "clk_gen_drv.svh"
    `include "clk_gen_mon.svh"
    `include "clk_gen_agt.svh"
    `include "clk_gen_seq.svh"
    
endpackage : clk_gen_pkg
