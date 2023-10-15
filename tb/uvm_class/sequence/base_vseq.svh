`include "custom_report_server.sv"

class base_vseq extends uvm_sequence;
    `uvm_object_utils(base_vseq)
    `uvm_declare_p_sequencer(vseqr_cls)

    vseqr_cls vseqr;
    //shift_seqr sh_seqr;
    //clk_gen_seqr clk_seqr;

    shift_send_seq sh_write_seq;
    shift_rec_seq  sh_read_seq;
    clk_gen_seq clk_seq;
    rst_gen_seq rst_seq;

    function new(string name = "base_vseq");
        super.new(name);
        sh_write_seq  = shift_send_seq::type_id::create("sh_write_seq");
        sh_read_seq  = shift_rec_seq::type_id::create("sh_read_seq");
        clk_seq = clk_gen_seq::type_id::create("clk_seq");
        rst_seq = rst_gen_seq::type_id::create("rst_seq");

    endfunction

    virtual task body();
        `uvm_create_on(sh_write_seq, p_sequencer.shift_wr_seqr)
        `uvm_create_on(sh_read_seq , p_sequencer.shift_rd_seqr)
        `uvm_create_on(clk_seq     , p_sequencer.clk_gen_seqr )
        `uvm_create_on(rst_seq     , p_sequencer.rst_gen_seqr )
    endtask : body

    task reset();
        rst_seq.rst_o = 0;
        `uvm_send(rst_seq);
        clk_seq.rep_cnt = 20;
        `uvm_send(clk_seq)
        rst_seq.rst_o = 1;
        `uvm_send(rst_seq);
    endtask : reset

endclass : base_vseq