`include "custom_report_server.sv"

class vseqr_cls extends uvm_sequencer;
    `uvm_component_utils(vseqr_cls)

    //uvm_sequencer#(shift_tran) shift_in_out_seqr;
    //uvm_sequencer#(clk_gen_trans) clk_seqr;
    shift_seqr shift_in_out_seqr;
    clk_gen_seqr clk_gen_seqr;
    function new(string name = "vseqr_cls", uvm_component parent = null);
        super.new(name, parent);

    endfunction

endclass : vseqr_cls