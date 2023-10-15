`timescale 1ns/1ps
`include "rst_gen_if.sv"

package rst_gen_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    typedef enum {
        ASYNC = 0,
        SYNC  = 1
    } async_sync_t;

    `include "rst_gen_cfg.svh"
    `include "rst_gen_trans.svh"
    `include "rst_gen_seqr.svh"
    `include "rst_gen_drv.svh"
    `include "rst_gen_mon.svh"
    `include "rst_gen_agt.svh"
    `include "rst_gen_seq.svh"

    
endpackage : rst_gen_pkg
