class shift_seq extends uvm_sequence#(shift_tran);
    `uvm_object_utils(shift_seq)

    uvm_sequence_item item;
    shift_seqr pseqr;
    shift_tran t_req;
    shift_tran t_rsp;

    logic in = 0;
    logic oe = 0;
    logic out = 0;

    function new (string name = "");
        super.new(name);
        t_req = shift_tran::type_id::create("t_req");
        t_rsp = shift_tran::type_id::create("t_rsp");
    endfunction 

    task body;
    endtask : body
endclass : shift_seq

class shift_send_seq extends shift_seq;
    `uvm_object_utils(shift_send_seq)

    function new (string name = "");
        super.new(name);
    endfunction 

    task body;
        this.start_item(this.t_req,, this.pseqr);
        t_req.op = SHIFT_WR;
        t_req.out = out;
        this.finish_item(this.t_req);
        this.get_response(this.t_rsp, this.t_req.get_transaction_id());
    endtask : body
endclass : shift_send_seq

class shift_rec_seq extends shift_seq;
    `uvm_object_utils(shift_rec_seq)

    function new (string name = "");
        super.new(name);
    endfunction 

    task body;
        this.start_item(this.t_req,, this.pseqr);
        t_req.op = SHIFT_RD;
        t_req.oe = oe;
        this.finish_item(this.t_req);
        this.get_response(this.t_rsp, this.t_req.get_transaction_id());
        in = t_rsp.in;
    endtask : body
endclass : shift_rec_seq
