class rst_gen_seq extends uvm_sequence#(rst_gen_trans);
    `uvm_object_utils(rst_gen_seq)

    logic rst_o;

    function new (string name = "");
        super.new(name);
    endfunction 

    task body;
        req = rst_gen_trans::type_id::create("req");
        start_item(req);
        req.rst_o = rst_o;
        finish_item(req);
    endtask : body

endclass : rst_gen_seq