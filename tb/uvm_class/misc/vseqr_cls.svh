`include "custom_report_server.sv"

class vseqr_cls extends uvm_sequencer;
    `uvm_component_utils(vseqr_cls)

    clk_gen_seqr clk_gen_seqr;
    rst_gen_seqr rst_gen_seqr;
    shift_seqr   shift_wr_seqr;
    shift_seqr   shift_rd_seqr;
    function new(string name = "vseqr_cls", uvm_component parent = null);
        super.new(name, parent);

    endfunction

endclass : vseqr_cls