`include "custom_report_server.sv"

class base_vseq extends uvm_sequence;
    `uvm_object_utils(base_vseq)
    `uvm_declare_p_sequencer(vseqr_cls)

    vseqr_cls vseqr;
    shift_seqr sh_seqr;
    clk_gen_seqr clk_seqr;

    shift_seq sh_seq;
    clk_gen_seq clk_seq;
    rst_gen_seq rst_seq;

    function new(string name = "base_vseq");
        super.new(name);
        sh_seq  = shift_seq::type_id::create("sh_seq");
        clk_seq = clk_gen_seq::type_id::create("clk_seq");
        rst_seq = rst_gen_seq::type_id::create("rst_seq");

    endfunction

    virtual task body();
        `uvm_create_on(sh_seq, p_sequencer.shift_in_out_seqr)
        `uvm_create_on(clk_seq, p_sequencer.clk_gen_seqr)
        `uvm_create_on(rst_seq, p_sequencer.rst_gen_seqr)

        reset();

        repeat (100) begin
            `uvm_send(sh_seq)
        end

        clk_seq.rep_cnt = 50;
        `uvm_send(clk_seq)

        repeat (100) begin
            `uvm_send(sh_seq)
        end
        
        reset();

        clk_seq.rep_cnt = 200;
        `uvm_send(clk_seq)
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