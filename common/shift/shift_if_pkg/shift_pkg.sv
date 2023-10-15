`timescale 1ns/1ps
`include "shift_if.sv"

package shift_pkg;

    typedef enum {
        SHIFT_WR = 0,
        SHIFT_RD = 1
    } SHIFT_OP_t;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "shift_cfg.svh"
    `include "shift_tran.svh"
    `include "shift_seqr.svh"
    `include "shift_drv.svh"
    `include "shift_mon.svh"
    `include "shift_agt.svh"
    `include "shift_seq.svh"    
    
endpackage : shift_pkg
