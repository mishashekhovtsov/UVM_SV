`include "custom_report_server.sv"

class base_vseq extends uvm_sequence;
    `uvm_object_utils(base_vseq)
    `uvm_declare_p_sequencer(vseqr_cls)

    vseqr_cls vseqr;
    shift_seqr sh_seqr;
    clk_gen_seqr clk_seqr;

    shift_seq sh_seq;
    clk_gen_seq clk_seq;

    function new(string name = "base_vseq");
        super.new(name);
        sh_seq  = shift_seq::type_id::create("sh_seq");
        clk_seq = clk_gen_seq::type_id::create("clk_seq");

    endfunction

    virtual task body();
        `uvm_create_on(sh_seq, p_sequencer.shift_in_out_seqr)
        `uvm_create_on(clk_seq, p_sequencer.clk_gen_seqr)

        /*clk_seq.rep_cnt = 10;
        `uvm_send(clk_seq)*/
        #10;
        repeat (10000) begin
            `uvm_send(sh_seq)
        end

        clk_seq.rep_cnt = 50;
        `uvm_send(clk_seq)

        repeat (10000) begin
            `uvm_send(sh_seq)
        end

        clk_seq.rep_cnt = 100;
        `uvm_send(clk_seq)
    endtask : body

endclass : base_vseq