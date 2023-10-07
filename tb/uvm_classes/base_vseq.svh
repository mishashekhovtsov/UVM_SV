`include "custom_report_server.sv"

class base_vseq extends uvm_sequence;
    `uvm_object_utils(base_vseq)
    `uvm_declare_p_sequencer(vseqr_cls)

    //vseqr_cls vseqr;
    shift_seqr sh_seqr;
    clk_gen_seqr clk_seqr;
    //uvm_sequencer#(shift_tran) sh_seqr;
    //uvm_sequencer#(clk_gen_trans) clk_seqr;

    shift_seq sh_seq;
    clk_gen_seq clk_seq;

    function new(string name = "base_vseq");
        super.new(name);
        sh_seq  = shift_seq::type_id::create("sh_seq");
        clk_seq = clk_gen_seq::type_id::create("clk_seq");

        //`uvm_create(sh_seq)
    endfunction

    virtual task body();
        /*if(!$cast(vseqr, m_sequencer)) begin
            `uvm_error("ERR", "vseqr cast failed")
        end*/

        /*sh_seqr  =  vseqr.shift_in_out_seqr;
        clk_seqr =  vseqr.clk_gen_seqr;*/

        repeat (16) begin
            sh_seq.start(p_sequencer.shift_in_out_seqr);
            //`uvm_send(sh_seq);
        end

        clk_seq.rep_cnt = 50;
        `uvm_info("REP_CNT", $sformatf("clk_seq.rep_cnt = %d", clk_seq.rep_cnt), UVM_LOW)
        clk_seq.start(p_sequencer.clk_gen_seqr);

        repeat (16) begin
            sh_seq.start(p_sequencer.shift_in_out_seqr);
            //`uvm_send(sh_seq);
        end

        clk_seq.rep_cnt = 100;
        `uvm_info("REP_CNT", $sformatf("clk_seq.rep_cnt = %d", clk_seq.rep_cnt), UVM_LOW)
        clk_seq.start(p_sequencer.clk_gen_seqr);
    endtask : body

endclass : base_vseq